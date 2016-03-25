module FidorApi

  class CardLimits < Resource
    extend ModelAttribute
    extend AmountAttributes

    amount_attribute :atm_limit
    amount_attribute :transaction_single_limit
    amount_attribute :transaction_volume_limit

    def self.find(access_token, id)
      new(request(access_token: access_token, endpoint: "/cards/#{id}/limits"))
    end

    def self.change(access_token, id, limits = {})
      new(limits).tap do |record|
        record.set_attributes request(
          method:       :put,
          access_token: access_token,
          endpoint:     "/cards/#{id}/limits",
          body:         record.as_json
        )
      end
    end

    module ClientSupport
      def card_limits(id)
        CardLimits.find(token.access_token, id)
      end

      def change_card_limits(id, limits)
        CardLimits.change(token.access_token, id, limits)
      end
    end
  end

end
