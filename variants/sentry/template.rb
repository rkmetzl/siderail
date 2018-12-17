source_dir = 'variants/sentry'.freeze

unless @sentry_dsn.blank?
  # Add the sentry token to the .env file
end

copy_file "#{source_dir}/sentry.rb", 'config/initializers/sentry.rb'

insert_into_file 'app/controllers/application_controller.rb', after: /ActionController::Base\n/ do
<<-EOF
  before_action :set_raven_context
EOF
end

insert_into_file 'app/controllers/application_controller.rb', before: /^end/ do
<<-EOF

  def set_raven_context
    Raven.extra_context(
      params: params.to_unsafe_h,
      url: request.url
    )
  end
EOF
end
