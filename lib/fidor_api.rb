require "faraday"
require "active_support"
require "active_support/core_ext"
require "active_model"
require "model_attribute"
require "json"

module FidorApi
  extend self

  attr_accessor :configuration

  class Configuration
    attr_accessor :callback_url, :oauth_url, :api_url, :client_id, :client_secret, :htauth_user, :htauth_password, :logging
  end

  def configure
    self.configuration = Configuration.new
    self.configuration.logging = true
    yield configuration
  end
end

require "fidor_api/version"
require "fidor_api/errors"
require "fidor_api/token"
require "fidor_api/auth"
require "fidor_api/resource"
require "fidor_api/collection"
require "fidor_api/amount_attributes"
require "fidor_api/user"
require "fidor_api/account"
require "fidor_api/customer"
require "fidor_api/msisdn"
require "fidor_api/transaction_details"
require "fidor_api/transaction"
require "fidor_api/preauth_details"
require "fidor_api/preauth"
require "fidor_api/transfer"
require "fidor_api/client"
