package model

import "time"

type Task struct {
	ID        uint       `json:"id" gorm:"primaryKey"`
	Title     string     `json:"title" gorm:"not null"`
	Status    TaskStatus `json:"status" gorm:"type:varchar(16);not null;default:todo"`
	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
	User      User       `json:"user" gorm:"foreignKey:UserId;constraint:OnDelete:CASCADE"` // 关联用户，Task属于用户；User被删除的时候，Task也会被删除
	UserId    uint       `json:"user_id" gorm:"not null"`
}
