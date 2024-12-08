package db

import (
	"database/sql"
	"fmt"
	"os"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

var Database *sql.DB

func ConnectDB() {
	var (
		err     error
		enverr  error
		localDB *sql.DB
	)
	enverr = godotenv.Load()
	if enverr != nil {
		panic(enverr)
	}

	dbUsername := os.Getenv("DB_USERNAME")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbHost := os.Getenv("DB_HOST")

	dbUrl := fmt.Sprintf("postgres://%s:%s@%s:5432/freedomdb", dbUsername, dbPassword, dbHost)

	localDB, err = sql.Open("postgres", dbUrl)
	if err != nil {
		panic(err)
	}

	if err = localDB.Ping(); err != nil {
		panic(err)
	}
	fmt.Println("The database is connected")

	Database = localDB
}
