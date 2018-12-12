GOCMD=go
GOGET=$(GOCMD) get
GOCLEAN=$(GOCMD) clean
GOBUILD=$(GOCMD) build
GOTEST=$(GOCMD) test
GOINSTALL=$(GOCMD) install
DEP=dep

GOXCMD=gox -cgo

TARGET="dist/datastore-tools_{{.OS}}_{{.Arch}}/{{.Dir}}"

BINARY_NAME := datastore-tools
SRCS := $(shell git ls-files '*.go')

all: dep test build

dep:
	$(GOGET) github.com/golang/dep/cmd/dep
	$(GOGET) github.com/mitchellh/gox
	$(DEP) ensure

test: $(SRCS)
	$(GOTEST)

build: datastore-tools

$(BINARY_NAME): $(SRCS)
	$(GOBUILD) -o $(BINARY_NAME)

pkg: linux_pkg window_pkg

linux_pkg:
	$(GOXCMD) -os "linux" -arch "386 amd64" -output $(TARGET)

window_pkg:
	CC=x86_64-w64-mingw32-gcc $(GOXCMD) -os "windows" -arch "amd64" -output $(TARGET)
	CC=i686-w64-mingw32-gcc $(GOXCMD) -os "windows" -arch "386" -output $(TARGET)

pkg_macOS:
	$(GOXCMD) -os "darwin" -arch "386 amd64" -output ${TARGET}

install:
	$(GOINSTALL)

clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
	rm -rf dist

.PHONY: all dep test build pkg install clean
