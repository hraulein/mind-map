package main

import (
	"github.com/gin-gonic/gin"
	"log"
	"os"
	"net/http"
	"context"
    "fmt"
	"time"
	// 载入本地包
	"github.com/hraulein/mind-map/internal/config"
)

func main() {
	// 加载配置
	cfg := config.Load("conf.d/config.yaml")
	cfg.PrintBanner()

	// 初始化Gin
	gin.SetMode(cfg.Server.Mode)
	r := gin.New()

	// 中间件
	r.Use(gin.Logger())
	r.Use(TimeoutMiddleware(cfg.Server.Timeout))

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

	log.Printf("Service starting | Port on %d | Mode on (%s mode)", cfg.Server.Port, cfg.Server.Mode)
	// 启动服务
	server := &http.Server{
		Addr:         fmt.Sprintf(":%d", cfg.Server.Port),
		Handler:      r,
		ReadTimeout:  cfg.Server.Timeout,
		WriteTimeout: cfg.Server.Timeout,
	}

	log.Printf("Service started succeeded")
	if err := server.ListenAndServe(); err != nil {
		log.Fatalf("Server startup failed: %v", err)
	}

}

func TimeoutMiddleware(timeout time.Duration) gin.HandlerFunc {
	return func(c *gin.Context) {
		ctx, cancel := context.WithTimeout(c.Request.Context(), timeout)
		defer cancel()
		c.Request = c.Request.WithContext(ctx)
		c.Next()
	}
}