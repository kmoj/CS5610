#!/bin/bash

export PORT=5300

cd ~/www/task_tracker2
./bin/task_tracker2 stop || true
./bin/task_tracker2 start

