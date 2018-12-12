Yet Another Rails Generator
===========================

## Description
A generator for Rails apps, designed with some boilerplate settings to get you up and running fast.

This generator configures a Rails installation using the following technologies:

**postgres** database

**puma** web server

**kaminari** for pagination

**friendly_id** for URL slugs

**sidekiq** for async tasks

**sass**, **jquery**, and **bootstrap** for frontend excellence

**awesome_print**, **pry**, **web-console**, and **dotenv** for dev efficiency

**vcr**, **selenium**, **capybara**, and **factory_bot** for testing

## Requirements
This template currently depends on you having the following:
- Ruby 2.5.x
- Rails 5.2.x
- PostgreSQL
- Redis

## Installation
To start, you should have the following services installed and running locally
- Postgres
- Redis

On OS X, you can install these by running the following:

```
brew install postgres redis
```

You may need to start these services manually:
```
brew services start postgres
brew services start redis
```

This generator relies on Ruby 2.5.x and Rails 5.2.x, as well as Bundler:
```
rvm install 2.5
gem install bundler
gem install rails
```
If you're using rbenv or another Ruby version manager, ensure you have at least version 2.5 of Ruby MRI installed.

All other dependencies will be installed when the script is run.

## Running the Generator
Run with the following command:
```
rails new myapp -T -d postgresql -m https://raw.githubusercontent.com/rkmetzl/siderail/master/template.rb
```

## Inspiration and Thanks

Much of the code and design in this repository was borrowed from the work of others.  Big thanks to the originators of those projects.  Here are some existing app generators that had a significant impact on this work:

- https://github.com/damienlethiec/modern-rails-template
- https://github.com/excid3/jumpstart
- https://github.com/mattbrictson/rails-template
