#!/bin/sh

if ! [ -f ".git/hooks/post_checkout" ]; then
    echo "Copying git hooks..."
    cp git-hooks/* .git/hooks
    echo "Done"
fi
