package main

import (
	"github.com/gin-gonic/gin"
	"log"
	"os"
)

func main() {
	// 生产模式配置
	gin.SetMode(gin.ReleaseMode)
	r := gin.New()
	r.Use(gin.Logger()) 
	// r.SetTrustedProxies([]string{"127.0.0.1"})
	// 首页路由（智能检测）
	r.GET("/", func(c *gin.Context) {
		if _, err := os.Stat("/app/index.html"); err == nil {
			c.File("/app/index.html")
		} else if _, err := os.Stat("/app/dist/index.html"); err == nil {
			c.File("/app/dist/index.html")
		} else {
			c.String(404, "/app/index.html | /app/dist/index.html not found")
		}
	})

	if _, err := os.Stat("/app/dist"); err == nil {
		r.Static("/dist", "/app/dist")
	}

	// 启动服务器
	port := ":8080"
	log.Printf("Service started | Port %s | Access http://localhost%s", port, port)
	if err := r.Run(port); err != nil {
		log.Fatal("Service startup failed: ", err)
	}
}