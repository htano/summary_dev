# Load the Rails application.
require File.expand_path('../application', __FILE__)

unless defined?(RAILS_ROOT)
  RAILS_ROOT = Rails.root.to_s
end

# Initialize the Rails application.
SummaryDev::Application.initialize!
