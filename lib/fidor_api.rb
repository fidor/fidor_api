require 'fidor_api/version'

require 'securerandom'
require 'json'

require 'active_model'
require 'faraday'
require 'faraday_middleware'
require 'model_attribute'

module FidorApi
  autoload :Client,      'fidor_api/client'
  autoload :Collection,  'fidor_api/collection'
  autoload :Environment, 'fidor_api/environment'
  autoload :Errors,      'fidor_api/errors'
  autoload :Model,       'fidor_api/model'
  autoload :Token,       'fidor_api/token'
end
