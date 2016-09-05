module FidorApi
  class CardLimits < Resource
    extend ModelAttribute
    include CardLimitAttribute

    attribute :id, :integer

    def self.find(access_token, id)
      attributes = request(access_token: access_token, endpoint: "/cards/#{id}/limits").body
      attributes.merge!(id: id)
      new(attributes)
    end

    def self.change(access_token, id, limits = {})
      attributes = limits.merge(id: id)

      new(attributes).tap do |record|
        record.set_attributes request(
          method:       :put,
          access_token: access_token,
          endpoint:     "/cards/#{id}/limits",
          body:         record.as_json
        ).body
      end
    end

    def as_json
      attributes.slice(:limits)
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
