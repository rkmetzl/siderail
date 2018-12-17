insert_into_file 'Gemfile', "gem 'slim-rails'\n", after: /["']kaminari['"]\n/
insert_into_file 'Gemfile', "gem 'html2slim'\n", after: /["']kaminari['"]\n/

run 'bundle install'
run 'erb2slim app/views/ app/views/'
