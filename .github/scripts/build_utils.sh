#!/bin/bash
set -euo pipefail

# 严格模式：遇到错误立即退出，未定义变量报错
[ "${DEBUG:-false}" == "true" ] && set -x

# 标签生成函数（无敏感操作）
generate_tags() {
  local docker_user=$1
  local container_name=$2
  local release_tag=$3
  local git_sha=$4

  if [[ -n "${release_tag}" && "${release_tag}" != "none" ]]; then
    echo "${docker_user}/${container_name}:sha-${git_sha:0:6},${docker_user}/${container_name}:${release_tag},${docker_user}/${container_name}:latest"
  else
    local date_tag=$(date +'%Y.%m.%d')
    echo "${docker_user}/${container_name}:sha-${git_sha:0:6},${docker_user}/${container_name}:${date_tag},${docker_user}/${container_name}:latest"
  fi
}


send_notification() {
  : "${1?Gotify server URL required}"
  : "${2?Gotify token required}"
  : "${3?Container name required}"
  : "${4?Build status required}"
  : "${5?Trigger reason required}"
  : "${6?Image tag required}"
  : "${7?Run URL required}"

  local gotify_server=$1
  local gotify_token=$2
  local container_name=$3
  local build_status=$4
  local trigger_reason=$5
  local image_tag=$6
  local run_url=$7

  local title="${container_name} 构建通知"
  local priority=5
  [ "${build_status}" != "success" ] && priority=8


  local message=$(cat <<EOF
    项目: ${container_name}  \n
    状态: ${build_status}  \n
    触发: ${trigger_reason}  \n
    标签: ${image_tag}  \n
    提交: ${GITHUB_SHA:-unknown}  \n
EOF
)

  curl -fsS -X POST "${gotify_server}/message?token=${gotify_token}" -H "Content-Type: application/json" -d @- <<EOF
    { "title": "${title}", "message": "${message}", "priority": ${priority}, "extras": { "client::display": { "contentType": "text/markdown" }, "client::notification": { "click": { "url": "${run_url}" } }}}
EOF
}


main() {
  case "${1:-}" in
    generate_tags)
      shift
      generate_tags "$@"
      ;;
    send_notification)
      shift
      send_notification "$@"
      ;;
    *)
      echo "Usage: $0 [generate_tags|send_notification] args..."
      exit 1
      ;;
  esac
}

[ "${BASH_SOURCE[0]}" = "$0" ] && main "$@"