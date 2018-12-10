source_dir = 'variants/devise/spec'.freeze

insert_into_file 'Gemfile', "gem 'devise'\n", after: /["']kaminari['"]\n/

run 'bundle install'

generate 'devise:install'

generate :devise, @user_class[:down_string]

# Since we can expect to need to style the login and
# signup pages, we go ahead and generate these views
generate 'devise:views', '-v', 'registrations', 'sessions'

copy_file "#{source_dir}/factories/user.rb", "spec/factories/#{@user_class[:down_string]}.rb"
gsub_file "spec/factories/#{@user_class[:down_string]}.rb", "user", @user_class[:down_string]
copy_file "#{source_dir}/models/user_spec.rb", "spec/models/#{@user_class[:down_string]}_spec.rb", force: true
gsub_file "spec/models/#{@user_class[:down_string]}_spec.rb", "user", @user_class[:down_string]
gsub_file "spec/models/#{@user_class[:down_string]}_spec.rb", "User", @user_class[:up_string]
copy_file "#{source_dir}/support/helpers/session_helpers.rb", 'spec/support/helpers/session_helpers.rb'
gsub_file "spec/support/helpers/session_helpers.rb", "user", @user_class[:down_string]
copy_file "#{source_dir}/support/helpers.rb", 'spec/support/helpers.rb'
copy_file "#{source_dir}/support/devise.rb", 'spec/support/devise.rb'
