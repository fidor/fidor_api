module FidorApi
  module Environment
    module FidorDE
      autoload :Sandbox,    'fidor_api/environment/fidor_de/sandbox'
      autoload :Production, 'fidor_api/environment/fidor_de/production'
    end
  end
end
