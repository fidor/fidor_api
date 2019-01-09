module FidorApi
  class Client
    module DSL
      module Transfers
        module Generic
          def transfers(options = {})
            check_transfer_support! :generic
            fetch(:collection, FidorApi::Model::Transfer::Generic, 'transfers', options)
          end

          def transfer(id, options = {})
            check_transfer_support! :generic
            fetch(:single, FidorApi::Model::Transfer::Generic, "transfers/#{id}", options)
          end

          def new_transfer(attributes = {})
            check_transfer_support! :generic
            Model::Transfer::Generic.new(attributes)
          end

          def create_transfer(attributes = {}, options = {})
            check_transfer_support! :generic
            create(FidorApi::Model::Transfer::Generic, 'transfers', attributes, options)
          end

          def update_transfer(id, attributes = {}, options = {})
            check_transfer_support! :generic
            update(FidorApi::Model::Transfer::Generic, "transfers/#{id}", id, attributes, options)
          end
        end
      end
    end
  end
end
