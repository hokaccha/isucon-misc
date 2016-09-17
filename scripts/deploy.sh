#!/bin/bash
set -ex

cd $(dirname $0)

git pull --rebase origin master
sudo cp etc/nginx.conf /etc/nginx/nginx.conf
sudo cp etc/my.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

./prebench.sh

sudo systemctl restart mysql
sudo systemctl restart nginx
sudo systemctl restart isu-ruby
