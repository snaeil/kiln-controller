SERVICE_NAME := kiln-controller
SERVICE_TEMPLATE := $(CURDIR)/lib/init/$(SERVICE_NAME).service
SERVICE_TARGET := /etc/systemd/system/$(SERVICE_NAME).service
VENV := .venv
RUN_USER := $(shell id -un)
PYTHON := $(VENV)/bin/python3
PIP := $(VENV)/bin/pip

.PHONY: test lint dev-setup

install:
	sudo apt update
	sudo apt full-upgrade
	sudo apt dist-upgrade
	sudo apt install swig liblgpio-dev python3-dev
	python3 -m venv $(VENV)
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install -e .

enable-autostart:
	sed -e 's|@REPO_DIR@|$(REPO_DIR)|g' \
	    -e 's|@RUN_USER@|$(RUN_USER)|g' \
	    "$(SERVICE_TEMPLATE)" | \
	    sudo tee "$(SERVICE_TARGET)" >/dev/null
	sudo systemctl daemon-reload
	sudo systemctl enable "$(SERVICE_NAME)"

disable-aautostart:
	sudo systemctl disable kiln-controller
	sudo rm /etc/systemd/system/kiln-controller.service
	sudo systemctl daemon-reload

test: dev-setup
	uv run pytest Test -q

lint: dev-setup
	uv run ruff check .

dev-setup:
	UV_PROJECT_ENVIRONMENT=$(VENV) uv sync
