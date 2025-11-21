package dto

import "go-test-api/model"

// CreateTaskRequest 表示创建任务时客户端允许提交的字段，避免直接绑定内部模型。
type CreateTaskRequest struct {
	Title  string `json:"title"`
	Status string `json:"status"`
}

// UpdateTaskRequest 允许对任务进行部分更新；指针字段为 nil 表示不变。
type UpdateTaskRequest struct {
	Title  *string `json:"title"`
	Status *string `json:"status"`
}

// ToTask 将创建请求转换为领域模型 Task，并在此处做状态校验/默认值。
func (r CreateTaskRequest) ToTask(defaultStatus model.TaskStatus) (model.Task, error) {
	status := defaultStatus
	if r.Status != "" {
		parsed, err := model.ParseTaskStatus(r.Status)
		if err != nil {
			return model.Task{}, err
		}
		status = parsed
	}
	return model.Task{Title: r.Title, Status: status}, nil
}

// ApplyToUpdates 把更新请求转换为传给仓储层的更新 map，同时校验状态合法性。
func (r UpdateTaskRequest) ApplyToUpdates(updates map[string]interface{}) error {
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
