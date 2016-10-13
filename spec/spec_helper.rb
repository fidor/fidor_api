require "simplecov"

SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "fidor_api"
require "webmock/rspec"
require "vcr"
require "byebug"
require "shoulda-matchers"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.debug_logger = File.open('vcr.log', 'w')
end

FidorApi.configure do |config|
  config.callback_url    = "http://localhost:3000/auth/callback"
  config.oauth_url       = "https://aps.fidor.de"
  config.api_url         = "https://aps.fidor.de"
  config.client_id       = "client-id"
  config.client_secret   = "client-secret"
  config.htauth_user     = "htauth-user"
  config.htauth_password = "htauth-password"
  config.affiliate_uid   = "1398b666-6666-6666-6666-666666666666"
  config.logging         = false
end
