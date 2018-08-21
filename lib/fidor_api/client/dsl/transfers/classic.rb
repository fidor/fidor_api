module FidorApi
  class Client
    module DSL
      module Transfers
        module Classic
          def internal_transfers(options = {})
            check_transfer_support! :classic
            fetch(:collection, FidorApi::Model::Transfer::Classic::Internal, '/internal_transfers', options)
          end

          def internal_transfer(id, options = {})
            check_transfer_support! :classic
            fetch(:single, FidorApi::Model::Transfer::Classic::Internal, "/internal_transfers/#{id}", options)
          end

          def new_internal_transfer(attributes = {})
            check_transfer_support! :classic
            Model::Transfer::Classic::Internal.new(attributes)
          end

          def create_internal_transfer(attributes = {})
            check_transfer_support! :classic
            create(FidorApi::Model::Transfer::Classic::Internal, '/internal_transfers', attributes)
          end
        end
      end
    end
  end
end
