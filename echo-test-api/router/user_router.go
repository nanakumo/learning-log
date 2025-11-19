package router

import (
	"go-test-api/controller"

	"github.com/labstack/echo/v4"
)

func NewUserRouter(uc controller.UserController) *echo.Echo {
	// Echo instance
	e := echo.New()
	// endpoints
	e.POST("/signup", uc.SignUp)
	e.POST("/login", uc.Login)
	e.POST("/logout", uc.Logout)
	return e
}