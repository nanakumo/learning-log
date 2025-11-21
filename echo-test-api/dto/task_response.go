package dto

import (
	"go-test-api/model"
	"time"
)

// TaskResponse 控制器对外返回的视图模型，避免直接暴露内部模型。
type TaskResponse struct {
	ID        uint             `json:"id"`
	Title     string           `json:"title"`
	Status    model.TaskStatus `json:"status"`
	CreatedAt time.Time        `json:"created_at"`
	UpdatedAt time.Time        `json:"updated_at"`
}
