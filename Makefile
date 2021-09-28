#!/bin/bash -e -o pipefail

.PHONY: clean compile help jazzy project requirebrew requirejazzy requireswiftdoc requirexcodegen resetgit swiftdoc swiftlint test xcodegen

help: requirebrew xcodegen
	@echo Usage:
	@echo ""
	@echo "  make clean     - removes all generated products"
	@echo "  make compile   - compile package"
	@echo "  make jazzy     - generate jazzy docs (https://github.com/realm/jazzy)"
	@echo "  make project   - generates a xcode project with local dependencies"
	@echo "  make swiftdoc  - generate swift docs (https://github.com/SwiftDocOrg/swift-doc)"
	@echo "  make swiftlint - Run swiftlint"
	@echo "  make test      - Run tests using xcodebuild"
	@echo ""

clean:
	rm -rf .build
	rm -rf .swiftpm
	rm -rf build
	rm -rf Package.resolved

swiftdoc: requireswiftdoc
	mkdir -p .build/swiftdocs
	@PROJECT_NAME="$(shell xcodebuild -showBuildSettings | grep PROJECT_NAME | awk '{print $$NF}')"; \
	swift doc generate sources/main --module-name $$PROJECT_NAME --format html --output .build/swiftdocs
	@echo "Docs generated at .build/swiftdocs" 
	@echo "To serve the docs run: cd .build/swiftdocs; python -m SimpleHTTPServer 8080"
	@echo "Browse the docs at http://127.0.0.1:8080"

swiftlint:
	swift run swiftlint

jazzy: requirejazzy
	mkdir -p .build/jazzy
	@PROJECT_MODULE_NAME="$(shell xcodebuild -showBuildSettings | grep PRODUCT_MODULE_NAME | awk '{print $$NF}')"; \
	jazzy --output .build/jazzy --module $$PROJECT_MODULE_NAME --swift-build-tool spm --sdk simulator --build-tool-arguments -Xswiftc,-swift-version,-Xswiftc,5,-Xswiftc,-sdk,-Xswiftc,"`xcrun --sdk iphonesimulator --show-sdk-path`",-Xswiftc,"-target",-Xswiftc,"x86_64-apple-ios14.4-simulator"
	@echo "Browse the docs at .build/jazzy/index.html"

compile:
	swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios14.4-simulator" 

test: project
	@PROJECT_NAME="$(shell xcodebuild -showBuildSettings | grep PROJECT_NAME | awk '{print $$NF}')"; \
	xcodebuild test -scheme $$PROJECT_NAME -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 12,OS=latest' CODE_SIGN_IDENTITY= CODE_SIGNING_REQUIRED=NO

project: requirexcodegen
	@PROJECT_NAME="$(shell xcodebuild -showBuildSettings | grep PROJECT_NAME | awk '{print $$NF}')"; \
	rm -rf "${PROJECT_NAME}.xcodeproj"; \
	xcodegen generate --project . --spec project.yml; \
	echo Generated $$PROJECT_NAME.xcodeproj

requirebrew:
	@if ! command -v brew &> /dev/null; then echo "Please install brew from https://brew.sh/"; exit 1; fi

requirejazzy:
	@if ! command -v brew &> /dev/null; then echo "Please install jazzy with gem install jazzy"; exit 1; fi

requireswiftdoc: requirebrew
	@if ! command -v swift-doc &> /dev/null; then echo "Please install swift-doc using 'brew install swiftdocorg/formulae/swift-doc'. Check the logs if trouble arises."; exit 1; fi

requirexcodegen: requirebrew
	@if ! command -v xcodegen &> /dev/null; then echo "Please install xcodegen using 'brew install xcodegen'"; exit 1; fi

resetgit:
	# @echo "This removes Git history, including tags. Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	DIR=$(shell cd -P -- '$(shell dirname -- "$0")' && pwd -P | sed 's:.*/::'); \
	rm -rf .git; \
	git init; \
	git add .; \
	git commit -m "Initial"; \
	git remote add origin git@github.com:janodev/$$DIR.git; \
	git push --force --set-upstream origin main; \
	git tag -d `git tag | grep -E '.'`; \
	git ls-remote --tags origin | awk '/^(.*)(s+)(.*[a-zA-Z0-9])$$/ {print ":" $$2}' | xargs git push origin; \
	git tag 1.0.0; \
	git push origin main --tags

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
