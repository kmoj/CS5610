#!/bin/bash

export PORT=5103
export MIX_ENV=prod
export GIT_PATH=/home/othello/project1/othello

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/othello ]; then
	echo mv ~/www/othello ~/old/$NOW
	mv ~/www/othello ~/old/$NOW
fi

mkdir -p ~/www/othello
REL_TAR=~/project1/othello/_build/prod/rel/othello/releases/0.0.1/othello.tar.gz
(cd ~/www/othello && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/othello/project1/othello/start.sh
CRONTAB

#. start.sh
