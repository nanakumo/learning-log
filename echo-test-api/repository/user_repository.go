package repository

import "go-test-api/model"

type UserRepository interface {
	GetUserByEmail(email string) (model.User, error)
	CreateUser(user *model.User) error
}