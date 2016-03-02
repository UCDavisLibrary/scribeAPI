#!/bin/sh

if ! [ -d "../ve" ]; then
    echo "Installing build system"
    python get-pip.py
    pip install virtualenv
    virtualenv ve --prompt="(labelthis) "
    ve/bin/pip install --upgrade pip
    ve/bin/pip install fabric

fi
