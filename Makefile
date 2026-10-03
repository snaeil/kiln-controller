VENV := venv
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

test:
	uv run pytest Test -q

lint:
	uv run ruff check .

dev-setup:
	UV_PROJECT_ENVIRONMENT=$(VENV) uv sync
