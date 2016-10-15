#!/bin/sh

set -ex

sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get -y install ruby2.3 ruby2.3-dev libxml2-dev zlib1g-dev
sudo gem install bundler
