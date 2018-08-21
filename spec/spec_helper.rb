require 'simplecov'

SimpleCov.start do
  minimum_coverage 99.47
end

require 'bundler/setup'
require 'fidor_api'

require 'byebug'
require 'webmock/rspec'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include AuthHelper
  config.include ClientHelper
end
