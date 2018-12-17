source_dir = 'variants/devise/spec'.freeze

generate 'devise:install'

generate :devise, @result[:user_class][:down_string]

# Since we can expect to need to style the login and
# signup pages, we go ahead and generate these views
generate 'devise:views', '-v', 'registrations', 'sessions'

copy_file "#{source_dir}/factories/user.rb", "spec/factories/#{@result[:user_class][:down_string]}.rb"
gsub_file "spec/factories/#{@result[:user_class][:down_string]}.rb", "user", @result[:user_class][:down_string]
copy_file "#{source_dir}/models/user_spec.rb", "spec/models/#{@result[:user_class][:down_string]}_spec.rb", force: true
gsub_file "spec/models/#{@result[:user_class][:down_string]}_spec.rb", "user", @result[:user_class][:down_string]
gsub_file "spec/models/#{@result[:user_class][:down_string]}_spec.rb", "User", @result[:user_class][:up_string]
copy_file "#{source_dir}/support/helpers/session_helpers.rb", 'spec/support/helpers/session_helpers.rb'
gsub_file "spec/support/helpers/session_helpers.rb", "user", @result[:user_class][:down_string]
copy_file "#{source_dir}/support/helpers.rb", 'spec/support/helpers.rb'
copy_file "#{source_dir}/support/devise.rb", 'spec/support/devise.rb'
