module FidorApi
  class Token
    ATTRIBUTES = %i[
      access_token
      expires_in
      token_type
      refresh_token
    ].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(args = {})
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def to_h
      Hash[ATTRIBUTES.map { |key| [key, instance_variable_get("@#{key}")] }]
    end
  end
end
