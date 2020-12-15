package main

import (
    "flag"
    "fmt"
    "math/rand"
    "net/http"
    "strconv"
)

var (
    num int
)

func add() string {
    m := rand.Intn(num)
    n := rand.Intn(num)
    s := strconv.Itoa(m + n)
    fmt.Printf("%v\n", s)
    return s
}

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, add())
}

func main() {
    flag.IntVar(&num, "num", 1000000, "num")
    flag.Parse()
    http.HandleFunc("/add", handler)
    http.ListenAndServe(":8080", nil)
}
