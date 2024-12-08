package db

type User struct {
	Name                string `json:"name"`
	Email               string `gorm:"uniqueIndex" json:"email"`
	PublicKey           string `gorm:"primaryKey" json:"publicKey"`
	PrivateKeyEncrypted string `json:"privateKeyEncrypted"`
}
