module FidorApi

  Error                  = Class.new(StandardError)
  ClientError            = Class.new(Error)
  UnauthorizedTokenError = Class.new(Error)
  InvalidRecordError     = Class.new(Error)
  NoUpdatesAllowedError  = Class.new(Error)

end
