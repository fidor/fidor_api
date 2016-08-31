module FidorApi
  module Beneficiary
    module ClientSupport
      def beneficiaries(options = {})
        Beneficiary::Base.all(token.access_token, options)
      end

      def beneficiary(id)
        Beneficiary::Base.find(token.access_token, id)
      end

      def delete_beneficiary(id)
        Beneficiary::Base.delete(token.access_token, id)
      end
    end
  end
end
