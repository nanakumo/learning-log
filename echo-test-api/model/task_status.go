package model

import "fmt"

// TaskStatus 是一个强类型，用于表示允许的任务状态，以避免使用魔法字符串。
type TaskStatus string

const (
	TaskStatusTodo  TaskStatus = "todo"
	TaskStatusDoing TaskStatus = "doing"
	TaskStatusDone  TaskStatus = "done"
)

// 返回所有有效的任务状态，用于验证或用户界面选项。
func AllTaskStatuses() []TaskStatus {
	return []TaskStatus{
		TaskStatusTodo,
		TaskStatusDoing,
		TaskStatusDone,
	}
}

// 这个函数用于将输入的字符串转换为TaskStatus类型，
// 并在输入无效时返回错误。
func ParseTaskStatus(s string) (TaskStatus, error) {
	switch TaskStatus(s) {
	case TaskStatusTodo, TaskStatusDoing, TaskStatusDone:
		return TaskStatus(s), nil
	default:
		return "", fmt.Errorf("invalid task status: %s", s)
	}
}
