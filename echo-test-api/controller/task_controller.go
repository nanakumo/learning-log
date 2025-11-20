package controller

import (
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
	// 从JWT token中获取userID
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))

	tasksRes, err := tc.taskUsecase.GetAllTasks(userID)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, tasksRes)
}

func (tc *taskController) GetTaskById(c echo.Context) error {
	// 从JWT token中获取userID
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))
	// 从URL参数中获取taskID
	id := c.Param("taskID")
	// stringをuintに変換
	taskID, _ := strconv.Atoi(id)
	taskRes , err := tc.taskUsecase.GetAllByUserID(userID, uint(taskID))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, "Invalid task ID")
	}
	return c.JSON(http.StatusOK, taskRes)
}

func (tc *taskController) CreateTask(c echo.Context) error {
	// 从JWT token中获取userID
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))
	task := model.Task{}
	if err := c.Bind(&task); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}
	task.UserId = userID
	taskRes, err := tc.taskUsecase.CreateTask(task)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusCreated, taskRes)
}

func (tc *taskController) UpdateTask(c echo.Context) error {
	// 从JWT token中获取userID
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))
	// 从URL参数中获取taskID
	id := c.Param("taskID")
	// stringをuintに変換
	taskID, _ := strconv.Atoi(id)
	task := model.Task{}
	if err := c.Bind(&task); err != nil {
		return c.JSON(http.StatusBadRequest, err.Error())
	}
	taskRes, err := tc.taskUsecase.UpdateTask(task, userID, uint(taskID))
	if err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.JSON(http.StatusOK, taskRes)
}

func (tc *taskController) DeleteTask(c echo.Context) error {
	// 从JWT token中获取userID
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	userID := uint(claims["user_id"].(float64))
	// 从URL参数中获取taskID
	id := c.Param("taskID")
	// stringをuintに変換
	taskID, _ := strconv.Atoi(id)
	if err := tc.taskUsecase.DeleteTask(userID, uint(taskID)); err != nil {
		return c.JSON(http.StatusInternalServerError, err.Error())
	}
	return c.NoContent(http.StatusNoContent)
}
