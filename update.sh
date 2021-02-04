#!/bin/bash

set -e

git add -A
git commit -a
git push
hexo clean
hexo d -g
