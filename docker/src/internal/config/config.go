package config

import (
	"log"
	"os"
	"sync"
	"time"
	"fmt"
	"gopkg.in/yaml.v3"
)

type AppConfig struct {
	App struct {
		Name    string `yaml:"name"`
		Author  string `yaml:"author"`
		Version string `yaml:"version"`
		Power   string `yaml:"power"`
		Build   string `yaml:"build"`
		License string `yaml:"license"`
		Source  string `yaml:"source"`
		Github  string `yaml:"github"`
		Year    int    `yaml:"year"`
	} `yaml:"app"`

	Server struct {
		Port    int           `yaml:"port"`
		Mode    string        `yaml:"mode"`
		Timeout time.Duration `yaml:"timeout"`
	} `yaml:"server"`
}

var (
	once     sync.Once
	instance *AppConfig
)

func Load(path string) *AppConfig {
	once.Do(func() {
		data, err := os.ReadFile(path)
		if err != nil {
			log.Fatalf("Failed to read config: %v", err)
		}

		var cfg AppConfig
		if err := yaml.Unmarshal(data, &cfg); err != nil {
			log.Fatalf("Failed to parse config: %v", err)
		}

		// 设置默认值
		if cfg.Server.Port == 0 {
			cfg.Server.Port = 8080
		}
		if cfg.Server.Mode == "" {
			cfg.Server.Mode = "release"
		}
		if cfg.Server.Timeout == 0 {
			cfg.Server.Timeout = 30 * time.Second
		}

		instance = &cfg
	})
	return instance
}

func (c *AppConfig) PrintBanner() {
	fmt.Println()
	fmt.Println("#################################################################################")
	fmt.Println("#\t\t\t\t\t\t\t\t\t\t#")
	fmt.Println("#\t\t    Name:", c.App.Name, "\t\t\t\t\t#")
	fmt.Println("#\t\t Version:", c.App.Version, "\t\t\t\t\t\t#")
	fmt.Println("#\t\t   Power:", c.App.Power, "\t\t\t\t\t#")
	fmt.Println("#\t\t   Build:", c.App.Build, "\t\t\t\t\t#")
	fmt.Println("#\t\t\t\t\t\t\t\t\t\t#")
	fmt.Println("#\t\t  Author:", c.App.Author, "\t\t\t#")
	fmt.Println("#\t\t  Github:", c.App.Github, "\t\t\t#")
	fmt.Println("#\t\t License:", c.App.License, "\t\t\t\t\t\t\t#")
	fmt.Println("#\t\t\t\t\t\t\t\t\t\t#")
	fmt.Println("#\t\t Copyright ©", c.App.Year, "By Hraulein\t\t\t\t\t#")
	fmt.Println("#\t\t\t\t\t\t\t\t\t\t#")
	fmt.Println("#################################################################################")
	fmt.Println()
}