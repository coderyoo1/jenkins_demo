package main

import "github.com/gin-gonic/gin"

func main() {
	router := gin.Default()

	router.GET("/hello", func(c *gin.Context) {
		c.String(200, "Hello, World!")
	})

	router.GET("/version", func(c *gin.Context) {
		c.String(200, "1.0.0")
	})

	// Start HTTP server on :8080
	if err := router.Run(":8080"); err != nil {
		panic(err)
	}
}
