module FidorApi
  module Customers
    class Confirmations < Connectivity::Resource
      extend ModelAttribute

      self.endpoint = Connectivity::Endpoint.new('/customers/confirmation', :collection)

      def self.create(*attributes)
        new(*attributes).save
      end

      private

      def persisted?
        false
      end
    end
  end
end
