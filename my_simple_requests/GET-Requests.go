package main

import (
	"net/http"
	"log"
	"io/ioutil"
	"time"
	"flag"
)

var INTERVAL int
var TARGET string

func main() {
	flag.IntVar(&INTERVAL, "INTERVAL", 1, "text description")
	flag.StringVar(&TARGET, "TARGET", "http://google.com", "text description")
	flag.Parse()
	doEvery((time.Duration(INTERVAL) * time.Second), MakeRequest)
}

func doEvery(d time.Duration, f func()) {
	for range time.Tick(d) {
		f()
	}
}

func MakeRequest() {
	resp, err := http.Get(TARGET)
	if err != nil {
		log.Fatalln(err)
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalln(err)
	}
	
	log.Println(string(body))
}

// go run /your/path/GET-Requests.go --INTERVAL 4 --TARGET "https://httpbin.org/get"
