module FidorApi
  class Client
    module DSL
      module Preauths
        def preauths(options = {})
          fetch(:collection, Model::Preauth, '/preauths', options)
        end

        def preauth(id, options = {})
          fetch(:single, Model::Preauth, "/preauths/#{id}", options)
        end
      end
    end
  end
end
