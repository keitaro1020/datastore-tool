package main

import (
	"fmt"
	"github.com/keitaro1020/datastore-tool/cmd"
	"os"
)

func main() {
	if err := cmd.RootCmd.Execute(); err != nil {
		fmt.Printf("%+v\n", err)
		os.Exit(1)
	}
}
