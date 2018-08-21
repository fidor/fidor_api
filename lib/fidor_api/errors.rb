module FidorApi
  module Errors
    Base         = Class.new(StandardError)
    NotSupported = Class.new(Base)
  end
end
