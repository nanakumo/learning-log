package usecase

import (
	"go-test-api/dto"
	"go-test-api/model"
	"go-test-api/repository"
	"go-test-api/validator"
)

type TaskUsecase interface {
	GetAllTasks(userID uint) (*[]dto.TaskResponse, error)
	GetAllByUserID(userID uint, taskID uint) (*dto.TaskResponse, error)
	CreateTask(task model.Task) (dto.TaskResponse, error)
	UpdateTask(updates map[string]interface{}, userID uint, taskID uint) (dto.TaskResponse, error)
	DeleteTask(userID uint, taskID uint) error
}

type taskUsecase struct {
	taskRepo repository.TaskRepository
	tv 	 validator.TaskValidator
}

func NewTaskUsecase(taskRepo repository.TaskRepository, tv validator.TaskValidator) TaskUsecase {
	return &taskUsecase{
		taskRepo: taskRepo,
		tv:       tv,
	}
}

func (tu *taskUsecase) GetAllTasks(userID uint) (*[]dto.TaskResponse, error) {
	tasks, err := tu.taskRepo.GetAllTasks(userID)
	if err != nil {
		return nil, err
	}
	// 转换为响应格式
	resTasks := []dto.TaskResponse{}
	for _, v := range *tasks {
		t := dto.TaskResponse{
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

func (tu *taskUsecase) GetAllByUserID(userID uint, taskID uint) (*dto.TaskResponse, error) {
	task, err := tu.taskRepo.GetTaskById(userID, taskID)
	if err != nil {
		return &dto.TaskResponse{}, err
	}
	resTask := dto.TaskResponse{
		ID:        task.ID,
		Title:     task.Title,
		Status:    task.Status,
		CreatedAt: task.CreatedAt,
		UpdatedAt: task.UpdatedAt,
	}
	return &resTask, nil
}

func (tu *taskUsecase) CreateTask(task model.Task) (dto.TaskResponse, error) {
	// 验证任务数据
	if err := tu.tv.TaskValidator(task);  err != nil {
		return dto.TaskResponse{}, err
	}
	// 创建任务
	if err := tu.taskRepo.CreateTask(&task); err != nil {
		return dto.TaskResponse{}, err
	}
	resTask := dto.TaskResponse{
		ID:        task.ID,
		Title:     task.Title,
		Status:    task.Status,
		CreatedAt: task.CreatedAt,
		UpdatedAt: task.UpdatedAt,
	}
	return resTask, nil
}

func (tu *taskUsecase) UpdateTask(updates map[string]interface{}, userID uint, taskID uint) (dto.TaskResponse, error) {
	// 验证更新数据
	tempTask := model.Task{}
	if title, ok := updates["title"].(string); ok {
		tempTask.Title = title
	}
	if err := tu.tv.TaskValidator(tempTask); err != nil {
		return dto.TaskResponse{}, err
	}
	// 更新任务
	updated, err := tu.taskRepo.UpdateTask(userID, taskID, updates)
	if err != nil {
		return dto.TaskResponse{}, err
	}
	resTask := dto.TaskResponse{
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
