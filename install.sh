#!/bin/sh

if ! [ -d "../ve" ]; then
    echo "Installing build system"
    python get-pip.py
    pip install virtualenv
    virtualenv ve --python=python3 --prompt="(labelthis) "
    ve/bin/pip install -r requirements.txt

fi
