// エントリーポイントに配置
package main

import (
	"fmt"
	"go-test-api/db"
	"go-test-api/model"
)

// Migrate 运行数据库自动迁移
func main() {
	dbConn := db.NewDB() // DB packageのNewDB funcでDB接続
	defer fmt.Println("Successfully Migrated")
	defer db.CloseDB(dbConn)
	dbConn.AutoMigrate(&model.User{}, &model.Task{})
}