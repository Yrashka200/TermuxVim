#!/bin/bash
pkg install -y python python-pip python-venv
pip install --upgrade pip
pip install python-lsp-server pylsp-mypy pyls-isort pyls-black black flake8 isort mypy pytest
echo "LSP_PYTHON=true" >>~/.config/termuxide/lsp.conf
