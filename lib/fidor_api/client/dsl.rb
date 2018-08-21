module FidorApi
  class Client
    module DSL
      autoload :ConfirmableActions, 'fidor_api/client/dsl/confirmable_actions'
      autoload :CoreData,           'fidor_api/client/dsl/core_data'
      autoload :Messages,           'fidor_api/client/dsl/messages'
      autoload :Transfers,          'fidor_api/client/dsl/transfers'
      autoload :Transactions,       'fidor_api/client/dsl/transactions'

      def self.included(klass)
        klass.include ConfirmableActions
        klass.include CoreData
        klass.include Messages
        klass.include Transfers
        klass.include Transactions
      end

      private

      def fetch(type, klass, endpoint, options)
        case type
        when :single
          klass.new(connection.get(endpoint, query: options).body)
        when :collection
          Collection.new(klass: klass, raw: connection.get(endpoint, query: options).body)
        else
          raise ArgumentError
        end
      end

      def create(klass, endpoint, attributes)
        request(klass, endpoint, :post, attributes)
      end

      def update(klass, endpoint, id, attributes)
        request(klass, endpoint, :put, attributes.merge(id: id))
      end

      def request(klass, endpoint, method, attributes) # rubocop:disable Metrics/AbcSize
        model = klass.new(attributes)
        model.tap do |m|
          response = connection.public_send(method, endpoint, body: m.as_json)
          m.set_attributes(response.body) if response.body.is_a?(Hash)
          m.confirmable_action_id = extract_confirmable_id(response.headers)
        end
      rescue Faraday::ClientError => e
        raise if e.response[:status] != 422
        model.tap { |m| m.parse_errors(e.response[:body]) }
      end

      POSSIBLE_CONFIRMABLE_HEADERS = %w[x-fidor-confirmation-path location].freeze

      def extract_confirmable_id(headers)
        return if (tuple = headers.detect { |key, _| POSSIBLE_CONFIRMABLE_HEADERS.include? key }).nil?
        tuple.last.split('/').last
      end
    end
  end
end
