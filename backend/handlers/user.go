package handlers

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"

	"freedom.com/m/v2/db"
	"freedom.com/m/v2/utils"
	"github.com/gagliardetto/solana-go"
)

func CreateUserHandler(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	email := r.URL.Query().Get("email")
	password := r.URL.Query().Get("password")

	privateKey, err := solana.NewRandomPrivateKey()
	if err != nil {
		panic(err)
	}
	publicKey := privateKey.PublicKey()

	encryptedPrivateKey, err := utils.Encrypt(privateKey.String(), password)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": err.Error()})
		return
	}

	var user db.User = db.User{
		Name:                name,
		Email:               email,
		PublicKey:           publicKey.String(),
		PrivateKeyEncrypted: encryptedPrivateKey,
	}

	query := "INSERT INTO users (name, email, public_key, private_key_encrypted) VALUES ($1, $2, $3, $4)"
	_, err = db.Database.Exec(query, name, email, publicKey.String(), encryptedPrivateKey)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": err.Error()})
		return
	}

	fmt.Println(user)

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(user)
}

func GetUserHandler(w http.ResponseWriter, r *http.Request) {
	email := r.URL.Query().Get("email")
	var user db.User

	query := "SELECT * FROM users WHERE email = $1"
	err := db.Database.QueryRow(query, email).Scan(&user.Name, &user.Email, &user.PublicKey, &user.PrivateKeyEncrypted)
	if err != nil {
		if err == sql.ErrNoRows {
			w.WriteHeader(http.StatusNotFound)
			json.NewEncoder(w).Encode(map[string]string{"error": err.Error()})
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": err.Error()})
		return
	}

	fmt.Println(user)

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(user)
}
