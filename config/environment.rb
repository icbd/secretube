# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!


# DIY global config
Rails.application.configure do
  config.assets.precompile += %w( welcome.css )
end