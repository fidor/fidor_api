module FidorApi
  module Transfer
    autoload :ACH,              'fidor_api/transfer/ach'
    autoload :Base,             'fidor_api/transfer/base'
    autoload :FPS,              'fidor_api/transfer/fps'
    autoload :Generic,          'fidor_api/transfer/generic'
    autoload :Internal,         'fidor_api/transfer/internal'
    autoload :P2pAccountNumber, 'fidor_api/transfer/p2p_account_number'
    autoload :P2pPhone,         'fidor_api/transfer/p2p_phone'
    autoload :P2pUsername,      'fidor_api/transfer/p2p_username'
    autoload :Pending,          'fidor_api/transfer/pending'
    autoload :SEPA,             'fidor_api/transfer/sepa'
    autoload :Swift,            'fidor_api/transfer/swift'
    autoload :BankInternal,     'fidor_api/transfer/bank_internal'
    autoload :Utility,          'fidor_api/transfer/utility'
  end
end
