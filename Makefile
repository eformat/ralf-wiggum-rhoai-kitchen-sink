PORT ?= 8887
DOCS_DIR := $(shell pwd)
SITE_DIR := $(DOCS_DIR)/www

.PHONY: install build build-35 build-36 serve serve-35 serve-36 stop clean

install:
	cd $(DOCS_DIR) && npm install

build: build-35

build-35: install
	rm -rf $(SITE_DIR)
	cd $(DOCS_DIR) && npx antora site-35.yml --stacktrace
	touch $(SITE_DIR)/.nojekyll

build-36: install
	rm -rf $(DOCS_DIR)/www-36
	cd $(DOCS_DIR) && npx antora site-36.yml --stacktrace
	touch $(DOCS_DIR)/www-36/.nojekyll

stop:
	@fuser -k $(PORT)/tcp 2>/dev/null || true
	@echo "Freed port $(PORT)"

serve: serve-35

serve-35: build-35
	@fuser -k $(PORT)/tcp 2>/dev/null || true
	@echo "Serving at http://localhost:$(PORT)"
	python3 -m http.server $(PORT) --directory $(SITE_DIR)

serve-36: build-36
	@fuser -k $(PORT)/tcp 2>/dev/null || true
	@echo "Serving at http://localhost:$(PORT)"
	python3 -m http.server $(PORT) --directory $(DOCS_DIR)/www-36

clean:
	rm -rf $(SITE_DIR) $(DOCS_DIR)/www-36
