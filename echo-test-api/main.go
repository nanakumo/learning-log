package main

import (
	"go-test-api/controller"
	"go-test-api/db"
	"go-test-api/repository"
	"go-test-api/router"
	"go-test-api/usecase"
	"go-test-api/validator"
)

func main() {
	db := db.NewDB()
	uv := validator.NewUserValidator()
	tv := validator.NewTaskValidator()
	userRepository := repository.NewUserRepository(db)
	userUsecase := usecase.NewUserUsecase(userRepository, uv)
	userController := controller.NewUserController(userUsecase)
	taskRepository := repository.NewTaskRepository(db)
	taskUsecase := usecase.NewTaskUsecase(taskRepository, tv)
	taskController := controller.NewTaskController(taskUsecase)
	e := router.NewRouter(userController, taskController)
	// echoのinstanceをを使ってサーバー起動
	e.Logger.Fatal(e.Start(":8088"))  // 失敗した場合はログにエラーを出力して終了
}
