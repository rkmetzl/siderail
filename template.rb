require 'fileutils'
require 'shellwords'
require 'bundler/inline'

YARG_REPO = 'https://github.com/rkmetzl/siderail.git'.freeze
RAILS_REQUIREMENT = '~> 5.2.0'.freeze

def build_app!
  puts "initializing..."

  install_gem 'tty-prompt' # Used for this script
  install_gem 'pastel'
  install_gem 'highline'

  debug_print('Checking your environment setup...')

  unless TTY::Prompt::VERSION
    puts "TTY was not able to install. Check that bundler is working correctly."
    return
  end

  # Template set up checks
  assert_minimum_rails_version
  add_template_repository_to_source_path

  input_confirm = false
  while !input_confirm
    prompt = TTY::Prompt.new(help_color: :yellow, prefix: '[?] ')
    @result = get_user_input(prompt)
    pp @result
    debug_print("CONFIRM:")
    input_confirm = prompt.yes?("Are the above settings all correct?", default: false)
  end

  debug_print("Applying settings")

  # Take action

  debug_print('Copying root config files...')
  # Copy root config files
  template 'ruby-version.tt', '.ruby-version', force: true
  template 'Gemfile.tt', 'Gemfile', force: true
  copy_file 'gitignore', '.gitignore', force: true
  template 'example.env.tt'
  copy_file 'Procfile'
  copy_file 'Procfile.dev'
  template 'README.md.tt', force: true

  debug_print('Templating app...')
  # Copy base application files
  apply 'app/template.rb'
  apply "bin/template.rb"
  apply 'config/template.rb'
  apply 'lib/template.rb'
  apply 'spec/template.rb'

  after_bundle do
    git :init

    stop_spring

    # Copy variants as necessary
    apply 'variants/devise/template.rb'         if @result.dig(:user, :authentication)
    apply 'variants/pundit/template.rb'         if @result.dig(:user, :authorization)
    apply 'variants/sentry/template.rb'         if @result["sentry"]
    apply 'variants/simple_form/template.rb'
    apply 'variants/active_storage/template.rb' if @result["active_storage"]

    # This should run last since it converts all generated ERB
    # to HAML
    case @result[:views]
    when "haml"
      apply 'variants/haml/template.rb'
    when "slim"
      apply 'variants/slim/template.rb'
    else
      debug_print "Using ERB"
    end

    debug_print('Running bin/setup to finish setting up your environment...')
    run 'bin/setup'

    debug_print('Updating your binstubs')
    binstubs = %w(annotate bundler sidekiq)
    run "bundle binstubs #{binstubs.join(' ')} --force"

    git add: '.'
    git commit: %Q{ -m 'Initial generator setup.' }

    debug_print('Success!')
  end
end



# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("siderail-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      YARG_REPO,
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{siderail/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

# Installs and uses any gems we need for running this templating script itself.
# These won't necessarily be included in the new project's gemfile.
def install_gem(gemname)
  if !Gem::Specification::find_all_by_name(gemname).any?
    gemfile(true) do
      source 'https://rubygems.org'
      gem gemname
    end
  end
  require gemname
end

def assert_minimum_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

def stop_spring
  run 'spring stop'
end

def debug_print(message = '')
  puts Pastel.new.yellow message
end

def get_user_input(prompt)
  views = [
    "haml",
    "erb",
    "slim"
  ]

  generator_options = [
    "helper",
    "assets",
    "javascripts",
    "stylesheets",
    "jbuilder"
  ]

  result = prompt.collect do
    # ORM
    key(:activestorage).yes?("Do you want to use ActiveStorage?")

    key(:generators).multi_select("Enable which generators?", generator_options, default: [1])

    # User Management
    if prompt.yes?("Will this app have users?")
      key(:user) do
        key(:model_name).ask("What is the name of your user model?", default: "user")
        key(:authentication).yes?("Do you want to install Devise to manage user authentication?")
        key(:authorization).yes?("Do you want to install Pundit to manage user access control?")
      end
    end

    key(:sentry).yes?("Do you want to use Sentry for error reporting?")

    # Views
    key(:views).select("What view templating system would you like to use?", views)
  end

  # Make some variables easily accessible
  user_const = (result.dig(:user, :model_name) || "user").underscore
  result[:user_class] = {
    up_string: user_const.camelize,
    down_string: user_const
  }

  temp_generators = result[:generators]
  result[:generators] = {}.tap{ |h| generator_options.each {|g| h[g.to_sym] = temp_generators.index(g).present? } }

  result
end

build_app!
