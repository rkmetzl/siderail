insert_into_file 'Gemfile', "gem 'slim-rails', '~> 3.2'\n", after: /["']kaminari['"]\n/
insert_into_file 'Gemfile', "gem 'html2slim', '~> 3.2'\n", after: /["']kaminari['"]\n/

run 'bundle install'
run 'erb2slim app/views/ app/views/'
# run 'SLIM_RAILS_DELETE_ERB=true bin/rails slim:erb2slim'
