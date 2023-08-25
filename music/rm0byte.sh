#!/bin/bash

find . -size 0 -type f -print0 | xargs -0 rm -rf
