package handlers

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"

	"freedom.com/m/v2/utils"
)

type DeezerResponse struct {
	Data []Result `json:"data"`
}

type Result struct {
	Album struct {
		Cover       string `json:"cover"`
		CoverBig    string `json:"cover_big"`
		CoverMedium string `json:"cover_medium"`
		CoverSmall  string `json:"cover_small"`
		CoverXL     string `json:"cover_xl"`
		ID          int    `json:"id"`
		MD5Image    string `json:"md5_image"`
		Title       string `json:"title"`
		Tracklist   string `json:"tracklist"`
		Type        string `json:"type"`
	} `json:"album"`
	Artist struct {
		ID            int    `json:"id"`
		Link          string `json:"link"`
		Name          string `json:"name"`
		Picture       string `json:"picture"`
		PictureBig    string `json:"picture_big"`
		PictureMedium string `json:"picture_medium"`
		PictureSmall  string `json:"picture_small"`
		PictureXL     string `json:"picture_xl"`
		Tracklist     string `json:"tracklist"`
		Type          string `json:"type"`
	} `json:"artist"`
	Duration              int    `json:"duration"`
	ExplicitContentCover  int    `json:"explicit_content_cover"`
	ExplicitContentLyrics int    `json:"explicit_content_lyrics"`
	ExplicitLyrics        bool   `json:"explicit_lyrics"`
	ID                    int    `json:"id"`
	Link                  string `json:"link"`
	MD5Image              string `json:"md5_image"`
	Preview               string `json:"preview"`
	Rank                  int    `json:"rank"`
	Readable              bool   `json:"readable"`
	Title                 string `json:"title"`
	TitleShort            string `json:"title_short"`
	TitleVersion          string `json:"title_version"`
	Type                  string `json:"type"`
}

func GetSongs(w http.ResponseWriter, r *http.Request) {
	key := os.Getenv("RAPID_API_DEEZER_KEY")
	baseUrl := os.Getenv("RAPID_API_DEEZER_BASE_URL")
	host := os.Getenv("RAPID_API_DEEZER_HOST")

	query := r.URL.Query().Get("query")
	fmt.Println(query)

	url := fmt.Sprintf("%s/search?q=%s", baseUrl, query)
	fmt.Println(url)

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("x-rapidapi-key", key)
	req.Header.Add("x-rapidapi-host", host)

	res, err := http.DefaultClient.Do(req)
	utils.HandleError(w, err)

	defer res.Body.Close()
	body, err := io.ReadAll(res.Body)

	utils.HandleError(w, err)

	deezerResponse := DeezerResponse{}
	err = json.Unmarshal(body, &deezerResponse)
	utils.HandleError(w, err)

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	json.NewEncoder(w).Encode(deezerResponse)

}
