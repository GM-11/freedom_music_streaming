package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"freedom.com/m/v2/db"
	"freedom.com/m/v2/handlers"
)

func homeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	data := map[string]interface{}{
		"message": "Welcome to the Go Server!",
	}
	json.NewEncoder(w).Encode(data)
}

func main() {

	db.ConnectDB()

	http.HandleFunc("GET /", homeHandler)

	// User
	http.HandleFunc("POST /user", handlers.CreateUserHandler)
	http.HandleFunc("GET /user", handlers.GetUserHandler)

	// Songs
	http.HandleFunc("GET /songs", handlers.GetSongs)

	port := ":8080"

	fmt.Printf("Starting server on http://0.0.0.0%s\n", port)
	err := http.ListenAndServe("0.0.0.0:8080", nil)
	if err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}
