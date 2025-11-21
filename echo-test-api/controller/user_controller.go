package controller

import (
	"go-test-api/model"
	"go-test-api/usecase"
	"net/http"
	"os"
	"time"

	"github.com/labstack/echo/v4"
)

type UserController interface {
	SignUp(c echo.Context) error
	Login(c echo.Context) error
	Logout(c echo.Context) error
}

type userController struct {
	userUsecase usecase.UserUsecase
}

func NewUserController(userUsecase usecase.UserUsecase) UserController {
	return &userController{
		userUsecase: userUsecase,
	}
}

func ( uc *userController ) SignUp (c echo.Context) error {
	// clientから受け取ってきたrequest bodyを構造体に変換
	user := model.User{}
	// clientから送られてくるrequest bodyの値をuser objectのポインタが指し示す先の値に格納する
	// Bindはrequest bodyのJSONを構造体に変換する
	// エラー時はStatusBadRequestを返す
	if err := c.Bind(&user); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}
	// bindに成功した場合は、usecaseのSignUpを呼び出して、新規ユーザーを作成
	resUser, err := uc.userUsecase.SignUp(&user)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	// 新規ユーザー作成に成功した場合は、作成したユーザー情報を返す
	return c.JSON(http.StatusCreated, resUser)
}

func ( uc *userController ) Login (c echo.Context) error {
	// clientから受け取ってきたrequest bodyを構造体に変換
	user := model.User{}
	// clientから送られてくるrequest bodyの値をuser objectのポインタが指し示す先の値に格納する
	// Bindはrequest bodyのJSONを構造体に変換する
	// エラー時はStatusBadRequestを返す
	if err := c.Bind(&user); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}
	// bindに成功した場合は、usecaseのLoginを呼び出して、JWT tokenを取得
	tokenString, err := uc.userUsecase.Login(&user)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	// JWT tokenの取得に成功した場合は、cookieにセットして返す
	cookie := new(http.Cookie)
	cookie.Name = "token"
	cookie.Value = tokenString
	cookie.Expires =  time.Now().Add(24 * time.Hour)
	cookie.Path = "/"
	cookie.Domain = os.Getenv("API_DOMAIN")
	// cookie.Secure = true
	cookie.HttpOnly = true // JavaScriptからのアクセスを防ぐためにHttpOnlyを設定
	cookie.SameSite = http.SameSiteLaxMode // クロスサイトリクエストでもcookieを送信するためにSameSite=Noneを設定
	c.SetCookie(cookie) // SetCookieはレスポンスにSet-Cookieヘッダーを追加する
	return c.NoContent(http.StatusOK)
}

func ( uc *userController ) Logout (c echo.Context) error {
	// cookieを削除するために、有効期限を過去に設定したcookieをセットする
	cookie := new(http.Cookie)
	cookie.Name = "token"
	cookie.Value = ""
	cookie.Expires =  time.Now().Add(-1 * time.Hour) // 過去の日時を設定してcookieを削除
	cookie.Path = "/"
	cookie.Domain = os.Getenv("API_DOMAIN")
	// cookie.Secure = true
	cookie.HttpOnly = true
	cookie.SameSite = http.SameSiteLaxMode
	c.SetCookie(cookie)
	return c.NoContent(http.StatusOK)
}