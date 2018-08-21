module FidorApi
  module Model
    module Transfer
      module Classic
        class Base < Model::Base
          class << self
            def resource_name
              name.sub('FidorApi::Model::Transfer::Classic::', 'Transfer::')
            end
          end
        end
      end
    end
  end
end
