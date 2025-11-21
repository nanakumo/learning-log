package controller

import "go-test-api/model"

// 创建任务请求结构体，包含任务标题和状态。
type CreateTaskRequest struct {
	Title  string `json:"title"`
	Status string `json:"status"`
}

// 更新任务请求结构体，允许部分更新；nil表示“不更改”。
type UpdateTaskRequest struct {
	Title  *string `json:"title"`
	Status *string `json:"status"`
}

// 将创建任务请求转换为带有验证状态的任务实体。
func (r CreateTaskRequest) toTask(defaultStatus model.TaskStatus) (model.Task, error) {
	// 如果请求中未提供状态，则使用默认状态。
	status := defaultStatus
	// 如果提供了状态，则解析并验证它。
	if r.Status != "" {
		parsed, err := model.ParseTaskStatus(r.Status)
		if err != nil {
			return model.Task{}, err
		}
		status = parsed
	}
	return model.Task{Title: r.Title, Status: status}, nil
}

// 将更新请求转换为用于存储库更新的映射。
func (r UpdateTaskRequest) applyToUpdates(updates map[string]interface{}) error {
	if r.Title != nil {
		updates["title"] = *r.Title
	}
	if r.Status != nil {
		parsed, err := model.ParseTaskStatus(*r.Status)
		if err != nil {
			return err
		}
		updates["status"] = parsed
	}
	return nil
}
