OUT_DIR_SERVER := build

WEBPACK = node_modules/.bin/webpack
TSLINT = node_modules/.bin/tslint
STYLELINT = node_modules/.bin/stylelint
TSC = node_modules/.bin/tsc
SUPERVISOR = node_modules/.bin/supervisor
NODEMON = node_modules/.bin/nodemon
TSNODE = node_modules/.bin/ts-node

.PHONY: deps
deps:
	npm i

# Server
.PHONY: server.dev
server.dev:
	$(NODEMON) --exec "export TS_NODE_PROJECT=src/server/tsconfig.json && $(TSNODE) -r tsconfig-paths/register src/server/app.ts" -w src/server -e "ts"

.PHONY: server.build
server.build:
	$(TSC) -p src/server/tsconfig.json

.PHONY: server.run
server.run:
	NODE_PATH=$(OUT_DIR_SERVER) \
	NODE_ENVIRONMENT=production \
	node ./build/server/app.js

# Client
.PHONY: client.dev
client.dev:
	make copy.resources && \
	$(WEBPACK) -w

.PHONY: client.build
client.build:
	make copy.resources && \
	NODE_ENVIRONMENT=production $(WEBPACK)

.PHONY: copy.resources
copy.resources:
	cp -r ./src/client/resources build/

# Lintings
.PHONY: lint
lint:
	make lint.server && \
	make lint.client

.PHONY: lint.server
lint.server:
	$(TSLINT) -p src/server/tsconfig.json src/server/**/*.ts

.PHONY: lint.client
lint.client:
	$(TSLINT) -p src/client/tsconfig.json src/client/**/*.{ts,tsx} && \
	$(STYLELINT) src/client/**/*.scss
