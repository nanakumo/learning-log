package repository

import (
	"fmt"
	"go-test-api/model"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type TaskRepository interface {
	// userId uint是输入参数，表示要获取哪个用户的任务
	// tasks *[]model.Task是输出参数，表示获取到的任务列表。
	GetAllTasks (userID uint) (*[]model.Task, error)
	GetTaskById (userID uint, taskID uint) (*model.Task, error)
	// Create 接收的 task *model.Task 通常包含了要插入数据库的完整实体（包括 UserID 字段）
	CreateTask (task *model.Task) error
	// updates map[string]interface{} 用于传递要更新的字段和值
	UpdateTask (userID uint, taskID uint, updates map[string]interface{}) (*model.Task, error)
	DeleteTask (userID uint, taskID uint) error
}

type taskRepository struct {
	db *gorm.DB
}

func NewTaskRepository(db *gorm.DB) TaskRepository {
	return &taskRepository{
		db: db,
	}
}

func (tr *taskRepository) GetAllTasks(userID uint) (*[]model.Task, error) {
	// 通过Joins预加载关联的User数据
	// Oderでcreated_atの昇順にソートして取得
	tasks := []model.Task{}
	if err := tr.db.Joins("User").Where("user_id = ? ", userID).Order("created_at").Find(&tasks).Error; err != nil {
		return nil, err
	}
	return &tasks, nil
}

func (tr *taskRepository) GetTaskById(userID uint, taskID uint) (*model.Task, error) {
	task := model.Task{}
	// First中的第一个参数是写入的对象，第二个参数是查询条件
	// 显式在 Where 中同时指定 user_id 和 id，避免把 taskID 当作 First 的第二参数
	if err := tr.db.Joins("User").Where("tasks.user_id = ? AND tasks.id = ?", userID, taskID).First(&task).Error; err != nil {
		return nil, err
	}
	return &task, nil
}

func (tr *taskRepository) CreateTask(task *model.Task) error {
	if err := tr.db.Create(task).Error; err != nil {
		return err
	}
	return nil
}

func (tr *taskRepository) UpdateTask(userID uint, taskID uint, updates map[string]interface{}) (*model.Task, error) {
	task := &model.Task{}
	// 使用 Model(&model.Task{}) + Updates，并用 Returning + Scan 返回更新后的记录（Postgres 支持）
	if err := tr.db.Model(&model.Task{}).
		Clauses(clause.Returning{}).
		Where("user_id = ? AND id = ?", userID, taskID).
		Updates(updates).
		Scan(task).Error; err != nil {
		return nil, err
	}

	return task, nil
}

func (tr *taskRepository) DeleteTask(userID uint, taskID uint) error {
	task := &model.Task{}
	result := tr.db.Where("user_id = ? AND id = ?", userID, taskID).Delete(task)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("object does not exist")
	}
	return nil
}