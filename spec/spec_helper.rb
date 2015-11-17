require "simplecov"

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "fidor_api"
require "vcr"
require "byebug"
require "shoulda-matchers"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :faraday
end

FidorApi.configure do |config|
  config.callback_url  = "http://localhost:3000/auth/callback"
  config.oauth_url     = "https://aps.fidor.de"
  config.api_url       = "https://aps.fidor.de"
  config.client_id     = "client-id"
  config.client_secret = "client-secret"
  config.logging       = false
end
