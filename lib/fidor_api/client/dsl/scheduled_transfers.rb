module FidorApi
  class Client
    module DSL
      module ScheduledTransfers
        def scheduled_transfers(options = {})
          fetch(:collection, Model::ScheduledTransfer, 'scheduled_transfers', options)
        end
      end
    end
  end
end
