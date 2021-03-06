# source_paths.unshift(File.dirname(__FILE__))

insert_into_file "config/application.rb", before: /^  end/ do
  <<-EOF

    # Use sidekiq to process Active Jobs (e.g. ActionMailer's deliver_later)
    config.active_job.queue_adapter = :sidekiq

  EOF
end

template 'config/database.yml.tt', force: true
copy_file 'config/puma.rb', force: true
copy_file "config/sidekiq.yml"

apply "config/environments/development.rb"
apply "config/environments/production.rb"
apply "config/environments/test.rb"

copy_file 'config/initializers/generators.rb', force: true
copy_file 'config/initializers/kaminari.rb'
copy_file 'config/initializers/meta_tags.rb'
copy_file 'config/initializers/rotate_log.rb'
copy_file 'config/initializers/sidekiq.rb'

# update jbuilder

insert_into_file \
  "config/initializers/generators.rb",
  after: /config\.generators do \|g\|\n/ do

  <<-RUBY
    g.helper          #{@result[:generators][:helper]}
    g.assets          #{@result[:generators][:assets]}
    g.javascripts     #{@result[:generators][:javascripts]}
    g.stylesheets     #{@result[:generators][:stylesheets]}
    g.jbuilder        #{@result[:generators][:jbuilder]}
    g.template_engine #{@result[:views].to_s}
  RUBY
end
