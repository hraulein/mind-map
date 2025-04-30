#!/bin/bash

# ==============================================
# 配置区（硬编码默认值，可通过命令行参数覆盖）
# ==============================================
docker_user="hraulein"
multi_container="mind-map"
multi_container_tag="2025.04.29"

# ==============================================
# 函数定义区
# ==============================================

# 彩色日志输出
log() {
  local color=$1
  shift
  case $color in
    red)    printf "\033[31m%s\033[0m\n" "$*" ;;
    green)  printf "\033[32m%s\033[0m\n" "$*" ;;
    yellow) printf "\033[33m%s\033[0m\n" "$*" ;;
    blue)   printf "\033[34m%s\033[0m\n" "$*" ;;
    *)      printf "%s\n" "$*" ;;
  esac
}

# 清理临时资源
cleanup() {
  log yellow "清理临时资源..."
  # 删除临时容器
  sudo docker ps -a --filter "name=tmp_mind-map_" --format "{{.Names}}" 2>/dev/null | xargs -r sudo docker rm -f 2>/dev/null
  # 删除临时文件
  [[ -d "${tmp_dir}" ]] && rm -rf "${tmp_dir}"
}

# 测试单个平台
test_platform() {
  local platform="$1"
  local suffix="$2"
  local expected_output="$3"
  
  local image="${docker_user}/${multi_container}:${multi_container_tag}"
  local container_name="tmp_mind-map_${suffix}"
  local output_file="${tmp_dir}/httpdGIN-${suffix}"

  log blue "测试平台: ${platform}"
  
  # 拉取镜像
  log yellow "拉取镜像..."
  if ! sudo docker pull --platform "${platform}" "${image}"; then
    log red "❌ 拉取镜像失败"
    return 1
  fi

  # 创建临时容器
  log yellow "创建容器..."
  if ! sudo docker create --platform "${platform}" --name "${container_name}" "${image}"; then
    log red "❌ 创建容器失败"
    return 1
  fi

  # 提取可执行文件
  log yellow "提取文件..."
  if ! sudo docker cp "${container_name}:/httpdGIN" "${output_file}"; then
    log red "❌ 提取可执行文件失败"
    return 1
  fi

  # 验证文件架构
  log yellow "验证架构..."
  local actual_output
  if ! actual_output=$(file "${output_file}"); then
    log red "❌ 文件分析失败"
    return 1
  fi

  if [[ "${actual_output}" == *"${expected_output}"* ]]; then
    log green "✅ 通过: ${actual_output}"
    return 0
  else
    log red "❌ 失败: 预期包含 '${expected_output}'"
    log red "实际输出: ${actual_output}"
    return 1
  fi
}

# ==============================================
# 主程序
# ==============================================

# 解析命令行参数
while getopts "u:c:t:" opt; do
  case "${opt}" in
    u) docker_user="${OPTARG}" ;;
    c) multi_container="${OPTARG}" ;;
    t) multi_container_tag="${OPTARG}" ;;
    *) 
      echo "用法: $0 [-u docker用户] [-c 容器名] [-t 标签]" >&2
      exit 1
    ;;
  esac
done

# 平台定义（使用Bash 5.x关联数组）
declare -A platforms=(
  ["linux/amd64"]="amd64 ELF 64-bit LSB executable, x86-64"
  ["linux/arm64"]="arm64 ELF 64-bit LSB executable, ARM aarch64"
  ["linux/arm/v7"]="armv7 ELF 32-bit LSB executable, ARM"
)

# 初始化临时目录
tmp_dir="/tmp/multiarch_test_$(date +%s)"
mkdir -p "${tmp_dir}"

# 注册清理钩子
trap cleanup EXIT

# 打印测试信息
log green "========================================"
log green "多平台架构验证脚本"
log green "镜像: ${docker_user}/${multi_container}:${multi_container_tag}"
log green "临时目录: ${tmp_dir}"
log green "========================================"

# 执行测试
errors=0
for platform in "${!platforms[@]}"; do
  # 从关联数组提取值并分割
  IFS=' ' read -r suffix expected <<< "${platforms[$platform]}"
  if ! test_platform "${platform}" "${suffix}" "${expected}"; then
    ((errors++))
  fi
done

# 输出总结
if [[ ${errors} -eq 0 ]]; then
  log green "\n🎉 所有平台测试通过！"
else
  log red "\n❌ 测试完成，共发现 ${errors} 个错误！"
fi

exit ${errors}