#!/bin/bash -e -o pipefail

.PHONY: example

clean:
	rm -rf build
	rm -rf .swiftpm

example: 
	cd example
	rm -rf example.xcodeproj
	xcodegen generate --project example --spec example/project.yml && open example/example.xcodeproj
	cd ..
