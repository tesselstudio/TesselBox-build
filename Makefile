# Unified Build System for TesselBox

.PHONY: all pc mobile mobile-apk ios clean test

PC_DIR=../TesselBox-pc
MOBILE_DIR=../TesselBox-mobile

all: pc

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
cd $(MOBILE_DIR) && gomobile build -target=android -androidapi=21 -o TesselBox.apk ./cmd

ios:
@echo "Building iOS app..."
cd $(MOBILE_DIR) && gomobile build -target=ios -o TesselBox.app ./cmd

mobile-test:
cd $(MOBILE_DIR) && go test ./...

# Clean
clean:
rm -f $(PC_DIR)/tesselbox $(MOBILE_DIR)/tesselbox $(MOBILE_DIR)/*.apk

# Test all
test: pc-test mobile-test

