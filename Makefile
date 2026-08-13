VERSION := 0.18.6.3-cleanroom

.PHONY: build
build:
	docker build . -t sopplet/mbc:${VERSION} --progress=plain

.PHONY: push
push: 
	docker push sopplet/mbc:$(VERSION)
