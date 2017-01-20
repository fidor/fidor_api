require "faraday"
require "active_support"
require "active_support/core_ext"
require "active_model"
require "model_attribute"
require "json"

module FidorApi
  extend self

  attr_accessor :configuration

  autoload :Account,            'fidor_api/account'
  autoload :AmountAttributes,   'fidor_api/amount_attributes'
  autoload :ApprovalRequired,   'fidor_api/approval_required'
  autoload :Auth,               'fidor_api/auth'
  autoload :Beneficiary,        'fidor_api/beneficiary'
  autoload :Card,               'fidor_api/card'
  autoload :CardLimitAttribute, 'fidor_api/card_limit_attribute'
  autoload :CardLimits,         'fidor_api/card_limits'
  autoload :Client,             'fidor_api/client'
  autoload :Collection,         'fidor_api/collection'
  autoload :ConfirmableAction,  'fidor_api/confirmable_action'
  autoload :Connectivity,       'fidor_api/connectivity'
  autoload :Customer,           'fidor_api/customer'
  autoload :Customers,          'fidor_api/customers/confirmations'
  autoload :Message,            'fidor_api/message'
  autoload :Msisdn,             'fidor_api/msisdn'
  autoload :Password,           'fidor_api/password'
  autoload :Preauth,            'fidor_api/preauth'
  autoload :PreauthDetails,     'fidor_api/preauth_details'
  autoload :SessionToken,       'fidor_api/session_token'
  autoload :Token,              'fidor_api/token'
  autoload :TransactionDetails, 'fidor_api/transaction_details'
  autoload :Transaction,        'fidor_api/transaction'
  autoload :Transfer,           'fidor_api/transfer'
  autoload :User,               'fidor_api/user'
  autoload :Version,            'fidor_api/version'

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
    rescue LoadError
      configuration.logger.debug "NOTE: Install `faraday-detailed_logger` gem to get detailed log-output for debugging."
    end
  end
end

require "fidor_api/errors"
require "fidor_api/constants"
