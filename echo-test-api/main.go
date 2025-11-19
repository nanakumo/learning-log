package main

import (
	"go-test-api/controller"
	"go-test-api/db"
	"go-test-api/repository"
	"go-test-api/router"
	"go-test-api/usecase"
)

func main() {
	db := db.NewDB()
	userRepository := repository.NewUserRepository(db)
	userUsecase := usecase.NewUserUsecase(userRepository)
	userController := controller.NewUserController(userUsecase)
	e := router.NewUserRouter(userController)
	// echoのinstanceをを使ってサーバー起動
	e.Logger.Fatal(e.Start(":8088"))  // 失敗した場合はログにエラーを出力して終了
}
