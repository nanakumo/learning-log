package validator

import "go-test-api/model"
import validation "github.com/go-ozzo/ozzo-validation/v4"

type TaskValidator interface{
	TaskValidator(task model.Task) error
}

type taskValidator struct{}

func NewTaskValidator() TaskValidator {
	return &taskValidator{}
}

func (tv *taskValidator) TaskValidator(task model.Task) error {
	return validation.ValidateStruct(&task,
		validation.Field(
			&task.Title,
			validation.Required.Error("Title is required"),
			validation.RuneLength(1, 10).Error("limited max 10 characters"),
		),
	)
}