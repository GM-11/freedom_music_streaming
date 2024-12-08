package utils

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"fmt"
	"io"
)

func deriveKey(password string) []byte {
	hash := sha256.New()
	hash.Write([]byte(password))
	return hash.Sum(nil)
}
func Encrypt(privateKey string, password string) (string, error) {
	keyBytes := []byte(deriveKey(password))
	privateKeyBytes := []byte(privateKey)

	block, err := aes.NewCipher(keyBytes)
	if err != nil {
		return "", fmt.Errorf("error creating cipher: %v", err)
	}

	ciphertext := make([]byte, aes.BlockSize+len(privateKeyBytes))
	iv := ciphertext[:aes.BlockSize]
	if _, err := io.ReadFull(rand.Reader, iv); err != nil {
		return "", fmt.Errorf("error generating IV: %v", err)
	}

	stream := cipher.NewCFBEncrypter(block, iv)
	stream.XORKeyStream(ciphertext[aes.BlockSize:], privateKeyBytes)

	return base64.StdEncoding.EncodeToString(ciphertext), nil
}

func Decrypt(encryptedPrivateKey, password string) (string, error) {
	keyBytes := []byte(deriveKey(password))
	ciphertext, err := base64.StdEncoding.DecodeString(encryptedPrivateKey)
	if err != nil {
		return "", fmt.Errorf("error decoding base64: %v", err)
	}

	block, err := aes.NewCipher(keyBytes)
	if err != nil {
		return "", fmt.Errorf("error creating cipher: %v", err)
	}

	if len(ciphertext) < aes.BlockSize {
		return "", fmt.Errorf("ciphertext too short")
	}

	iv := ciphertext[:aes.BlockSize]
	ciphertext = ciphertext[aes.BlockSize:]

	stream := cipher.NewCFBDecrypter(block, iv)
	stream.XORKeyStream(ciphertext, ciphertext)

	return string(ciphertext), nil
}
