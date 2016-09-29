module FidorApi
  class CardLimits < Connectivity::Resource
    extend ModelAttribute
    include CardLimitAttribute

    self.endpoint = Connectivity::Endpoint.new('/cards/:id/limits', :resource)

    attribute :id, :integer

    def as_json
      attributes.slice(:limits)
    end
  end
end
