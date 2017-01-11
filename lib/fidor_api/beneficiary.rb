module FidorApi
  module Beneficiary
    autoload :Base,             'fidor_api/beneficiary/base'
    autoload :Generic,          'fidor_api/beneficiary/generic'
    autoload :ACH,              'fidor_api/beneficiary/ach'
    autoload :P2pAccountNumber, 'fidor_api/beneficiary/p2p_account_number'
    autoload :P2pPhone,         'fidor_api/beneficiary/p2p_phone'
    autoload :P2pUsername,      'fidor_api/beneficiary/p2p_username'
    autoload :Swift,            'fidor_api/beneficiary/swift'
    autoload :Unknown,          'fidor_api/beneficiary/unknown'

    module ClientSupport
      def beneficiaries(options = {})
        Beneficiary::Base.all(options)
      end

      def beneficiary(id)
        Beneficiary::Base.find(id)
      end

      def delete_beneficiary(id)
        Beneficiary::Base.delete(id)
      end
    end
  end
end
