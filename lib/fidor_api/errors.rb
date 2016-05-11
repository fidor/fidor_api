module FidorApi

  Error                  = Class.new(StandardError)
  ClientError            = Class.new(Error)
  UnauthorizedTokenError = Class.new(Error)
  InvalidRecordError     = Class.new(Error)
  NoUpdatesAllowedError  = Class.new(Error)

  class ValidationError < Error
    attr_accessor :fields

    def initialize(message, fields)
      super(message)
      self.fields = fields
    end
  end

end
