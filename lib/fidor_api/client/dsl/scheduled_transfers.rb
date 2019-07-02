module FidorApi
  class Client
    module DSL
      module ScheduledTransfers
        def scheduled_transfers(options = {})
          fetch(:collection, FidorApi::Model::ScheduledTransfer, 'scheduled_transfers', options)
        end

        def scheduled_transfer(id, options = {})
          fetch(:single, FidorApi::Model::ScheduledTransfer, "scheduled_transfers/#{id}", options)
        end

        def new_scheduled_transfer(attributes = {})
          FidorApi::Model::ScheduledTransfer.new(attributes)
        end

        def create_scheduled_transfer(attributes = {}, options = {})
          create(FidorApi::Model::ScheduledTransfer, 'scheduled_transfers', attributes, options)
        end

        def update_scheduled_transfer(id, attributes = {}, options = {})
          update(FidorApi::Model::ScheduledTransfer, "scheduled_transfers/#{id}", id, attributes, options)
        end

        def confirm_scheduled_transfer(id, options = {})
          request(:put, "scheduled_transfers/#{id}/confirm", {}, options[:headers])
        end
      end
    end
  end
end
