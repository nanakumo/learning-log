package repository

import (
	"go-test-api/model"

	"gorm.io/gorm"
)

type UserRepository interface {
	GetUserByEmail(user *model.User, email string) error
	CreateUser(user *model.User) error
}
type userRepository struct {
	// DB接続用のフィールドなどをここに追加
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) UserRepository {
	return &userRepository{db: db}
}

func (u *userRepository) GetUserByEmail(user *model.User, email string) error {
	// 送られてきた email が DB に存在するか確認
	// userが存在する場合は 、引数で受け取ったuser objectのアドレスが指し示す先の値の内容を検索したuserのobjectの内容で書き換えます
	// First メソッドは、最初のレコードを取得し、受け取った結果を*userに書き換える。見つからない場合はエラーを返す
	if err := u.db.Where("email = ?", email).First(user).Error; err != nil {
		return err
	}
	return nil
}

func (u *userRepository) CreateUser(user *model.User) error {
	// 新規ユーザーをDBに保存します。エラー時はそのまま返します。
	if err := u.db.Create(user).Error; err != nil {
		return err
	}
	return nil
}