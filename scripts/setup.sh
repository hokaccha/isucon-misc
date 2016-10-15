#!/bin/sh

set -ex

sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install build-essential git-core htop dstat
