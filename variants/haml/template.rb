insert_into_file 'Gemfile', "gem 'haml-rails', '~> 1.0'\n", after: /["']kaminari['"]\n/

run 'bundle install'

run 'bin/rails haml:erb2haml'
