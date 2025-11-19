package db

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func NewDB() *gorm.DB {
	if shouldLoadDotEnv() {
		if err := godotenv.Load(); err != nil {
			log.Fatalln(err)
		}
	}
	url := fmt.Sprintf("user=%s password=%s dbname=%s host=%s port=%s sslmode=disable",
		os.Getenv("POSTGRES_USER"),
		os.Getenv("POSTGRES_PASSWORD"),
		os.Getenv("POSTGRES_DB"),
		os.Getenv("POSTGRES_HOST"),
		os.Getenv("POSTGRES_PORT"),
	)
	db, err := gorm.Open(postgres.Open(url), &gorm.Config{})
	if err != nil {
		log.Fatalln(err)
	}
	fmt.Println("DB connected")
	return db
}

func CloseDB(db *gorm.DB) {
	sqlDB, err := db.DB()
	if err != nil {
		log.Fatalln(err)
	}
	sqlDB.Close()
	fmt.Println("DB disconnected")
}

// shouldLoadDotEnv は .env ファイルをロードすべきかどうかを判断する関数
func shouldLoadDotEnv() bool {
	env := os.Getenv("GO_ENV")
	if env == "dev" {
		return true
	}
	if env != "" {
		return false
	}
	if _, err := os.Stat(".env"); err == nil {
		return true
	}
	return false
}
