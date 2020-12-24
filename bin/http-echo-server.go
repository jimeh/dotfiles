/// 2>/dev/null; gorun "$0" "$@" ; exit $?
package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strconv"
	"strings"
)

var (
	port = flag.Int("p", 8080, "port to listen to")
	bind = flag.String("b", "127.0.0.1", "address to bind to")
)

func echoHandler(w http.ResponseWriter, req *http.Request) {
	fmt.Println("\n<----- Request Start ----->")
	fmt.Printf("%s %s\n", req.Method, req.URL.String())
	for h, v := range req.Header {
		fmt.Printf("%s: %s\n", h, strings.Join(v, ", "))
	}

	body, _ := ioutil.ReadAll(req.Body)
	if len(body) > 0 {
		fmt.Println()
		fmt.Println(string(body))
	}

	fmt.Println("<----- Request End ----->")
	w.WriteHeader(http.StatusOK)
}

func main() {
	flag.Parse()

	http.HandleFunc("/", echoHandler)

	address := (*bind) + ":" + (strconv.Itoa(*port))
	fmt.Printf("Listening on %s\n", address)
	log.Fatal(http.ListenAndServe(address, nil))
}
