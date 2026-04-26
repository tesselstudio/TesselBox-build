# Unified Build System for TesselBox

.PHONY: all pc mobile mobile-apk ios server clean test

PC_DIR=../TesselBox-pc
MOBILE_DIR=../TesselBox-mobile
SERVER_DIR=../TesselBox-server

all: pc mobile server

# PC/Desktop builds
pc:
	@echo "Building PC version..."
	cd $(PC_DIR) && go build -o tesselbox ./cmd/main.go

pc-run: pc
	cd $(PC_DIR) && ./tesselbox

pc-test:
	cd $(PC_DIR) && go test ./...

# Mobile builds
mobile: mobile-desktop

mobile-desktop:
	@echo "Building mobile (desktop mode)..."
	cd $(MOBILE_DIR) && go build -tags desktop -o tesselbox ./cmd/main.go

mobile-run: mobile-desktop
	cd $(MOBILE_DIR) && ./tesselbox

mobile-apk:
	@echo "Building Android APK..."
	cd $(MOBILE_DIR) && go run golang.org/x/mobile/cmd/gomobile@latest build -target android -androidapi 21 -o TesselBox.apk ./cmd

ios:
	@echo "Building iOS app..."
	cd $(MOBILE_DIR) && gomobile bind -target=ios -o TesselBox.app ./cmd

mobile-test:
	cd $(MOBILE_DIR) && go test ./...

# Server builds
server:
	@echo "Building server..."
	cd $(SERVER_DIR) && go build -o tesselbox-server ./cmd/main.go

server-run: server
	cd $(SERVER_DIR) && ./tesselbox-server

server-tui:
	@echo "Building server with TUI..."
	cd $(SERVER_DIR) && go build -o tesselbox-server ./cmd/main.go
	cd $(SERVER_DIR) && ./tesselbox-server -tui

server-test:
	cd $(SERVER_DIR) && go test ./...

# Clean
clean:
	rm -f $(PC_DIR)/tesselbox $(MOBILE_DIR)/tesselbox $(MOBILE_DIR)/*.apk $(SERVER_DIR)/tesselbox-server

# Test all
test: pc-test mobile-test server-test

