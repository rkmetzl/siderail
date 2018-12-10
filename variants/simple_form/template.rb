insert_into_file 'Gemfile', "gem 'simple_form'\n", after: /["']kaminari['"]\n/

run 'bundle install'

run 'bin/rails generate simple_form:install --bootstrap'
