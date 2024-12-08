package utils

import (
	"encoding/json"
	"log"
	"net/http"
)

func HandleError(w http.ResponseWriter, err error) {
	if err != nil {
		log.Fatal(err)
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": err.Error()})
		return
	}
}
