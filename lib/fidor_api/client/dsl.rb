module FidorApi
  class Client
    module DSL
      autoload :Accounts,           'fidor_api/client/dsl/accounts'
      autoload :Cards,              'fidor_api/client/dsl/cards'
      autoload :ConfirmableActions, 'fidor_api/client/dsl/confirmable_actions'
      autoload :CoreData,           'fidor_api/client/dsl/core_data'
      autoload :Messages,           'fidor_api/client/dsl/messages'
      autoload :Preauths,           'fidor_api/client/dsl/preauths'
      autoload :ScheduledTransfers, 'fidor_api/client/dsl/scheduled_transfers'
      autoload :StandingOrders,     'fidor_api/client/dsl/standing_orders'
      autoload :Transactions,       'fidor_api/client/dsl/transactions'
      autoload :Transfers,          'fidor_api/client/dsl/transfers'

      def self.included(klass)
        klass.include Accounts
        klass.include Cards
        klass.include ConfirmableActions
        klass.include CoreData
        klass.include Messages
        klass.include Preauths
        klass.include ScheduledTransfers
        klass.include StandingOrders
        klass.include Transactions
        klass.include Transfers
      end

      private

      def fetch(type, klass, endpoint, options)
        headers = options.delete(:headers) || {}

        case type
        when :single
          klass.new(connection.get(endpoint, query: options, headers: headers).body)
        when :collection
          Collection.new(klass: klass, raw: connection.get(endpoint, query: options, headers: headers).body)
        else
          raise ArgumentError
        end
      end

      def create(klass, endpoint, attributes, options = {})
        headers = options.delete(:headers) || {}

        request_model(klass, endpoint, :post, attributes, headers)
      end

      def update(klass, endpoint, id, attributes, options = {})
        headers = options.delete(:headers) || {}

        request_model(klass, endpoint, :put, attributes.merge(id: id), headers)
      end

      def request_model(klass, endpoint, method, attributes, headers = {}) # rubocop:disable Metrics/AbcSize
        model = klass.new(attributes)
        model.tap do |m|
          response = request(method, endpoint, m.as_json, headers)
          m.set_attributes(response.body) if response.body.is_a?(Hash)
          m.confirmable_action_id = extract_confirmable_id(response.headers)
        end
      rescue Faraday::ClientError => e
        raise if e.response[:status] != 422

        model.tap { |m| m.parse_errors(e.response[:body]) }
      end

      def request(method, endpoint, attributes, headers = {})
        connection.public_send(method, endpoint, body: attributes, headers: headers)
      end

      POSSIBLE_CONFIRMABLE_HEADERS = %w[x-fidor-confirmation-path location].freeze

      def extract_confirmable_id(headers)
        return if (tuple = headers.detect { |key, value| POSSIBLE_CONFIRMABLE_HEADERS.include?(key) && value.present? }).nil?

        tuple.last.split('/').last
      end
    end
  end
end
