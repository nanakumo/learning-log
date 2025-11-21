package controller

import (
	"go-test-api/dto"
	"go-test-api/model"
	"go-test-api/usecase"
	"net/http"
	"strconv"

	"github.com/golang-jwt/jwt/v5"
	"github.com/labstack/echo/v4"
)

type TaskController interface {
	GetAllTasks(c echo.Context) error
	GetTaskById(c echo.Context) error
	CreateTask(c echo.Context) error
	UpdateTask(c echo.Context) error
	DeleteTask(c echo.Context) error
}

type taskController struct {
	taskUsecase usecase.TaskUsecase
}

func NewTaskController(taskUsecase usecase.TaskUsecase) TaskController {
	return &taskController{
		taskUsecase: taskUsecase,
	}
}

func (tc *taskController) GetAllTasks(c echo.Context) error {
	// 从 Echo 的 context 里把中间件验证过的 JWT token 取出来
	token, ok := c.Get("user").(*jwt.Token)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token")
	}
	// 从 token 里把我们之前定义的自定义 Claims 取出来
	claims, ok := token.Claims.(*model.JWTClaims)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token claims")
	}
	// 通过 Claims 取出 userID
	userID := claims.UserID

	tasksRes, err := tc.taskUsecase.GetAllTasks(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, tasksRes)
}

func (tc *taskController) GetTaskById(c echo.Context) error {
	// 从JWT token中获取userID
	token, ok := c.Get("user").(*jwt.Token)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token")
	}
	claims, ok := token.Claims.(*model.JWTClaims)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token claims")
	}
	userID := claims.UserID
	// 从URL参数中获取taskID
	id := c.Param("taskID")
	// stringをuintに変換
	taskID, err := strconv.Atoi(id)
	if err != nil {
		return c.JSON(http.StatusBadRequest, "Invalid task ID")
	}
	taskRes, err := tc.taskUsecase.GetAllByUserID(userID, uint(taskID))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, "Invalid task ID")
	}
	return c.JSON(http.StatusOK, taskRes)
}

func (tc *taskController) CreateTask(c echo.Context) error {
	// 从JWT token中获取userID
	token, ok := c.Get("user").(*jwt.Token)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token")
	}
	claims, ok := token.Claims.(*model.JWTClaims)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token claims")
	}
	// 通过 Claims 取出 userID
	userID := claims.UserID
	// 从请求体中获取任务数据（使用 DTO 层，避免直接绑定内部模型）
	req := dto.CreateTaskRequest{}
	// Bind请求体到req结构体
	// 如果绑定失败，返回400错误
	if err := c.Bind(&req); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}
	// 将请求转换为任务实体，使用默认状态
	task, err := req.ToTask(model.TaskStatusTodo)
	if err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}
	// 设置任务的用户ID
	task.UserId = userID
	// 调用用例层的创建方法
	taskRes, err := tc.taskUsecase.CreateTask(task)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusCreated, taskRes)
}

func (tc *taskController) UpdateTask(c echo.Context) error {
	// 从JWT token中获取userID
	token, ok := c.Get("user").(*jwt.Token)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token")
	}
	claims, ok := token.Claims.(*model.JWTClaims)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token claims")
	}
	userID := claims.UserID
	// 从URL参数中获取taskID
	id := c.Param("taskID")
	// stringをuintに変換
	taskID, err := strconv.Atoi(id)
	if err != nil {
		return c.JSON(http.StatusBadRequest, "Invalid task ID")
	}
	// 从请求体中获取更新数据（使用 DTO 层，避免直接暴露内部模型）
	req := dto.UpdateTaskRequest{}
	// Bind请求体到req结构体
	// 如果绑定失败，返回400错误
	if err := c.Bind(&req); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}
	// 将更新请求转换为用于存储库更新的映射
	updates := map[string]interface{}{}
	// 如果转换失败，返回400错误
	if err := req.ApplyToUpdates(updates); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}
	// 调用用例层的更新方法
	taskRes, err := tc.taskUsecase.UpdateTask(updates, userID, uint(taskID))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, taskRes)
}

func (tc *taskController) DeleteTask(c echo.Context) error {
	// 从JWT token中获取userID
	token, ok := c.Get("user").(*jwt.Token)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token")
	}
	claims, ok := token.Claims.(*model.JWTClaims)
	if !ok {
		return c.JSON(http.StatusUnauthorized, "Invalid token claims")
	}
	userID := claims.UserID
	// 从URL参数中获取taskID
	id := c.Param("taskID")
	// stringをuintに変換
	taskID, err := strconv.Atoi(id)
	if err != nil {
		return c.JSON(http.StatusBadRequest, "Invalid task ID")
	}
	if err := tc.taskUsecase.DeleteTask(userID, uint(taskID)); err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.NoContent(http.StatusNoContent)
}
