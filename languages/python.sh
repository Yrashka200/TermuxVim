#!/bin/bash
pkg install -y python python-pip python-venv
pip install --upgrade pip
pip install black flake8 isort mypy pytest ipython jedi pynvim
