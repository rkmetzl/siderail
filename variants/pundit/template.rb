generate 'pundit:install'

insert_into_file 'app/controllers/application_controller.rb', after: /ActionController::Base\n/ do
<<-EOF
  include Pundit
EOF
end
