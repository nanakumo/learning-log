package router

import (
	"go-test-api/controller"
	"os"
	echojwt "github.com/labstack/echo-jwt/v4"
	"github.com/labstack/echo/v4"
)

func NewRouter(uc controller.UserController, tc controller.TaskController) *echo.Echo {
	// Echo instance
	e := echo.New()
	// endpoints
	e.POST("/signup", uc.SignUp)
	e.POST("/login", uc.Login)
	e.POST("/logout", uc.Logout)
	// Grouped routes
	t := e.Group("/tasks")
	// JWT Middleware
	t.Use(echojwt.WithConfig(echojwt.Config{
		SigningKey : []byte(os.Getenv("SECRET")),
		TokenLookup: "cookie:token",
	}))
	t.GET("", tc.GetAllTasks)
	t.GET("/:taskID", tc.GetTaskById)
	t.POST("", tc.CreateTask)
	t.PUT("/:taskID", tc.UpdateTask)
	t.DELETE("/:taskID", tc.DeleteTask)
	return e
}
