package validator

import (
	"go-test-api/model"

	validation "github.com/go-ozzo/ozzo-validation/v4"
	"github.com/go-ozzo/ozzo-validation/v4/is"
)

type UserValidator interface{
	UserValidator(user model.User) error
}

type userValidator struct{}

func NewUserValidator() UserValidator {
	return &userValidator{}
}

func (uv *userValidator) UserValidator(user model.User) error {
	return validation.ValidateStruct(&user,
		validation.Field(
			&user.Email,
			validation.Required.Error("Email is required"),
			validation.RuneLength(1, 30).Error("limited max 30 characters"),
			is.Email.Error("is not valid email format"),
		),
		validation.Field(
			&user.Password,
			validation.Required.Error("Password is required"),
			validation.RuneLength(6, 50).Error("limited 6 to 50 characters"),
		),
	)
}