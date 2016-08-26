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
    attr_accessor :callback_url, :oauth_url, :api_url, :api_path, :client_id, :client_secret, :htauth_user, :htauth_password, :affiliate_uid, :os_type, :logging, :logger, :verify_ssl
  end

  def configure
    self.configuration = Configuration.new.tap do |config|
      config.logging    = true
      config.logger     = Logger.new(STDOUT)
      config.os_type    = "iOS" # NOTE: As long as there is only iOS or Android we have to tell a fib ;)
      config.verify_ssl = true
    end
    yield configuration

    begin
      require "faraday/detailed_logger"
    rescue LoadError => e
      configuration.logger.debug "NOTE: Install `faraday-detailed_logger` gem to get detailed log-output for debugging."
    end
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
require "fidor_api/beneficiary"
require "fidor_api/card"
require "fidor_api/card_limits"
require "fidor_api/confirmable_action"
require "fidor_api/customer"
require "fidor_api/message"
require "fidor_api/msisdn"
require "fidor_api/session_token"
require "fidor_api/transaction_details"
require "fidor_api/transaction"
require "fidor_api/password"
require "fidor_api/preauth_details"
require "fidor_api/preauth"
require "fidor_api/transfer"
require "fidor_api/transfer/base"
require "fidor_api/transfer/generic"
require "fidor_api/transfer/ach"
require "fidor_api/transfer/fps"
require "fidor_api/transfer/internal"
require "fidor_api/transfer/sepa"
require "fidor_api/transfer/p2p_account_number"
require "fidor_api/transfer/p2p_phone"
require "fidor_api/transfer/p2p_username"
require "fidor_api/client"
require "fidor_api/approval_required"
