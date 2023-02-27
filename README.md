# README

## Introduction 

This is updated version of [Knowe](https://github.com/john-hamnavoe/knowe), this version has stimulus_reflex and all_futures removed. It worked well but tried to remove some dependancies and go to hotwire stack. With hotwire the filters are top of table columns have been bit more problematic (probably better to move filtering to outside the table in the future). 

## Using Template

Steps to use template:

* Use Template button at top of this repo

* git clone to local development machine

* Rename databases/redis etc. from knowe to `your app name`

* If npm < 7.1 rerun `bin/rails javascript:install:esbuild`

* Run `bundle update`

* Run `rails db:create db:migrate`

* Add remote original knowewire: 
  * `git remote add knowewire git@github.com:john-hamnavoe/knowewire.git`

## Merging Changes from Template

Merge changes from template:

* `git fetch knowewire`

* `git merge knowewire/main --allow-unrelated-histories`

* `rails db:migrate` (to apply new database changes)

First time probably need to do some merges to get the right change to database name etc.

## Running application 

* `foreman start -f procfile.dev`   

