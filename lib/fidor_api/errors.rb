module FidorApi

  Error                  = Class.new(StandardError)
  ClientError            = Class.new(Error)
  UnauthorizedTokenError = Class.new(Error)
  InvalidRecordError     = Class.new(Error)
  NoUpdatesAllowedError  = Class.new(Error)

  class ValidationError < Error
    attr_accessor :fields, :error_keys

    def initialize(message, fields, error_keys)
      super(message)
      self.fields = fields
      self.error_keys = error_keys
    end
  end

end
