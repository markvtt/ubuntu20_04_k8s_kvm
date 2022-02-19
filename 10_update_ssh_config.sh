#!/bin/bash

echo "
Host *
    StrictHostKeyChecking no
" | tee ~/.ssh/config    