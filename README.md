Yet Another Rails Generator
===========================

## Description

A generator for Rails apps, designed with some boilerplate settings to get you up and running fast.

## Requirements

This template currently depends on you having the following:
- Ruby 2.5.x
- Rails 5.2.x
- PostgreSQL
- Redis

## Running the Generator

Run with the following command:
```
rails new myapp -T -d postgresql -m https://raw.githubusercontent.com/rkmetzl/yarg/master/template.rb
```

## Inspiration and Thanks

Much of the code and design in this repository was borrowed from the work of others.  Big thanks to the originators of those projects.  Here are some existing app generators that had a significant impact on this work:

- https://github.com/damienlethiec/modern-rails-template
- https://github.com/excid3/jumpstart
- https://github.com/mattbrictson/rails-template

Out of the box:

Postgres database
Puma web server

sass, jquery, bootstrap views

kaminari for pagination
friendly_id for URL slugs

sidekiq for async tasks

awesome_print, pry, web-console, dotenv for dev efficiency

vcr, selenium, capybara, factory_boy for testing

