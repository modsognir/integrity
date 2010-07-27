#!/bin/sh

#echo "Friday1" | sudo -S ~/integrity/build.sh
#sh ~/integrity/build.sh

#rake db:drop RAILS_ENV=test && rake db:create RAILS_ENV=test && rake db:schema:load RAILS_ENV=test && rake db:schema:load RAILS_ENV=legacy_test SCHEMA="db/legacy_schema.rb"

cp ../../config/config.yml config/config.yml 
cp ../../config/database.yml config/database.yml
cp ../../config/sphinx.yml config/sphinx.yml
rm -rf ../imported_csv/
mkdir ../imported_csv/

bundle install
RAILS_ENV=test rake db:drop
RAILS_ENV=test rake db:create
RAILS_ENV=test rake db:schema:load
RAILS_ENV=legacy_test SCHEMA="db/legacy_schema.rb" rake db:schema:load
bundle exec spec spec
bundle exec cucumber

#rake ts:stop RAILS_ENV=test
#rake ts:rebuild RAILS_ENV=test
#bundle exec cucumber -f progress features/
#bundle exec spec spec/

