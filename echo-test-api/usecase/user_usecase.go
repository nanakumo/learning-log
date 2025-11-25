package usecase

import (
	"go-test-api/model"
	"go-test-api/repository"
	"go-test-api/validator"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

type UserUsecase interface {
	SignUp(user *model.User) (model.UserResponse, error)
	Login(user *model.User) (string , error) // 返回 JWT token
}

type userUsecase struct {
	userRepo repository.UserRepository //只依赖 UserRepository 的 interface
	uv 	 validator.UserValidator
}

// NewUser は UserUsecase のコンストラクタ（usecaseに依存性を注入するため）为了返回接口值
func NewUserUsecase(userRepo repository.UserRepository, uv validator.UserValidator) UserUsecase {
	return &userUsecase{userRepo: userRepo, uv: uv}
}

func (u *userUsecase) SignUp (user *model.User) (model.UserResponse, error) {
	// バリデーションを実行
	if err := u.uv.UserValidator(*user); err != nil {
		return model.UserResponse{}, err
	}
	// パスワードをハッシュ化
	hash, err := bcrypt.GenerateFromPassword([]byte(user.Password), 10)
	if err != nil {
		return model.UserResponse{}, err
	}
	newUser := model.User{Email: user.Email, Password: string(hash)}
	if err := u.userRepo.CreateUser(&newUser); err != nil {
		return model.UserResponse{}, err
	}
	resUser := model.UserResponse{
		ID:    newUser.ID,
		Email: newUser.Email,
	}
	return resUser, nil
}

// string 代表 JWT token
func (u *userUsecase) Login ( user *model.User) (string , error){
	// バリデーションを実行
	if err := u.uv.UserValidator(*user); err != nil {
		return "", err
	}
	// client から送られてきた email が DB に存在するか確認
	// 最初にemailで検索するuserのobjectを格納する変数
	storedUser := model.User{}
	// userRepoのGetUserByEmailを呼び出して、DBからemailでuserを取得
	if err := u.userRepo.GetUserByEmail(&storedUser, user.Email); err != nil {
		return "", err
	}
	// userが存在場合はパスワードを照合
	// bcryptのCompareHashAndPassword関数を使って、DBに保存されているハッシュ化されたパスワードと、clientから送られてきたパスワードを比較
	// 一致しない場合はエラーを返す
	if err := bcrypt.CompareHashAndPassword([]byte(storedUser.Password), []byte(user.Password)); err != nil {
		return "", err
	}
	// パスワードが一致した場合はJWT tokenを生成して返す
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": storedUser.ID,
		"exp":     time.Now().Add(time.Hour * 72).Unix(), // トークンの有効期限を72時間に設定
	})
	// secret keyで署名してtokenStringを生成
	tokenString, err := token.SignedString([]byte(os.Getenv("SECRET")))
	if err != nil {
		return "", err
	}
	return tokenString, nil
}
