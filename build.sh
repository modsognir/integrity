#!/bin/sh


RAILS_ENV=test bundle install 
cp ../../config/config.yml config/config.yml 
cp ../../config/database.yml config/database.yml
cp ../../config/sphinx.yml config/sphinx.yml
rm -rf ../imported_csv/
mkdir ../imported_csv/
