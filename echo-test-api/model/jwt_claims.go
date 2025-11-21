package model

import "github.com/golang-jwt/jwt/v5"

// 这个结构体用于定义JWT的载荷（Claims），
// 包含一个用户ID字段（UserID）和嵌入的注册声明（RegisteredClaims）。
// 通过定义这个结构体，可以在处理JWT时避免使用不安全的map断言，
// 提高代码的类型安全性和可读性。
type JWTClaims struct {
	UserID uint `json:"user_id"`
	jwt.RegisteredClaims
}
