# devise
if @result.dig(:user).present?
  insert_into_file 'Gemfile', "gem 'devise'\n", after: /["']kaminari['"]\n/
end

# pundit
if @result.dig(:user, :authorization)
  insert_into_file 'Gemfile', "gem 'pundit'\n", after: /["']devise['"]\n/
end


# sentry
if @result[:sentry]
  insert_into_file 'Gemfile', "gem 'sentry-raven'\n", after: /["']kaminari['"]\n/
end

case @result[:views]
when "haml"
  # haml
  insert_into_file 'Gemfile', "gem 'haml-rails', '~> 1.0'\n", after: /["']kaminari['"]\n/
when "slim"
  # slim
  insert_into_file 'Gemfile', "gem 'slim-rails'\n", after: /["']kaminari['"]\n/
  insert_into_file 'Gemfile', "gem 'html2slim'\n", after: /["']kaminari['"]\n/
end

# simple_form
insert_into_file 'Gemfile', "gem 'simple_form'\n", after: /["']kaminari['"]\n/

run 'bundle install'
