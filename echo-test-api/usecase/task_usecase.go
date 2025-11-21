package usecase

import (
	"go-test-api/model"
	"go-test-api/repository"
)

type TaskUsecase interface {
	GetAllTasks(userID uint) (*[]model.TaskResponse, error)
	GetAllByUserID(userID uint, taskID uint) (*model.TaskResponse, error)
	CreateTask(task model.Task) (model.TaskResponse, error)
	UpdateTask(updates map[string]interface{}, userID uint, taskID uint) (model.TaskResponse, error)
	DeleteTask(userID uint, taskID uint) error
}

type taskUsecase struct {
	taskRepo repository.TaskRepository
}

func NewTaskUsecase(taskRepo repository.TaskRepository) TaskUsecase {
	return &taskUsecase{
		taskRepo: taskRepo,
	}
}

func (tu *taskUsecase) GetAllTasks(userID uint) (*[]model.TaskResponse, error) {
	tasks, err := tu.taskRepo.GetAllTasks(userID)
	if err != nil {
		return nil, err
	}
	// 转换为响应格式
	resTasks := []model.TaskResponse{}
	for _, v := range *tasks {
		t := model.TaskResponse{
			ID:        v.ID,
			Title:     v.Title,
			Status:    v.Status,
			CreatedAt: v.CreatedAt,
			UpdatedAt: v.UpdatedAt,
		}
		resTasks = append(resTasks, t)
	}
	return &resTasks, nil
}

func (tu *taskUsecase) GetAllByUserID(userID uint, taskID uint) (*model.TaskResponse, error) {
	task, err := tu.taskRepo.GetTaskById(userID, taskID)
	if err != nil {
		return &model.TaskResponse{}, err
	}
	resTask := model.TaskResponse{
		ID:        task.ID,
		Title:     task.Title,
		Status:    task.Status,
		CreatedAt: task.CreatedAt,
		UpdatedAt: task.UpdatedAt,
	}
	return &resTask, nil
}

func (tu *taskUsecase) CreateTask(task model.Task) (model.TaskResponse, error) {
	if err := tu.taskRepo.CreateTask(&task); err != nil {
		return model.TaskResponse{}, err
	}
	resTask := model.TaskResponse{
		ID:        task.ID,
		Title:     task.Title,
		Status:    task.Status,
		CreatedAt: task.CreatedAt,
		UpdatedAt: task.UpdatedAt,
	}
	return resTask, nil
}

func (tu *taskUsecase) UpdateTask(updates map[string]interface{}, userID uint, taskID uint) (model.TaskResponse, error) {
	updated, err := tu.taskRepo.UpdateTask(userID, taskID, updates)
	if err != nil {
		return model.TaskResponse{}, err
	}
	resTask := model.TaskResponse{
		ID:        updated.ID,
		Title:     updated.Title,
		Status:    updated.Status,
		CreatedAt: updated.CreatedAt,
		UpdatedAt: updated.UpdatedAt,
	}
	return resTask, nil
}

func (tu *taskUsecase) DeleteTask(userID uint, taskID uint) error {
	if err := tu.taskRepo.DeleteTask(userID, taskID); err != nil {
		return err
	}
	return nil
}
