module FidorApi
  class Client
    module DSL
      autoload :Cards,              'fidor_api/client/dsl/cards'
      autoload :ConfirmableActions, 'fidor_api/client/dsl/confirmable_actions'
      autoload :CoreData,           'fidor_api/client/dsl/core_data'
      autoload :Messages,           'fidor_api/client/dsl/messages'
      autoload :Preauths,           'fidor_api/client/dsl/preauths'
      autoload :Transactions,       'fidor_api/client/dsl/transactions'
      autoload :Transfers,          'fidor_api/client/dsl/transfers'

      def self.included(klass)
        klass.include Cards
        klass.include ConfirmableActions
        klass.include CoreData
        klass.include Messages
        klass.include Preauths
        klass.include Transactions
        klass.include Transfers
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

      def update(klass, endpoint, id, attributes, headers = {})
        request(klass, endpoint, :put, attributes.merge(id: id), headers)
      end

      def request(klass, endpoint, method, attributes, headers = {}) # rubocop:disable Metrics/AbcSize
        model = klass.new(attributes)
        model.tap do |m|
          response = connection.public_send(method, endpoint, body: m.as_json, headers: headers)
          m.set_attributes(response.body) if response.body.is_a?(Hash)
          m.confirmable_action_id = extract_confirmable_id(response.headers)
        end
      rescue Faraday::ClientError => e
        raise if e.response[:status] != 422

        model.tap { |m| m.parse_errors(e.response[:body]) }
      end

      POSSIBLE_CONFIRMABLE_HEADERS = %w[x-fidor-confirmation-path location].freeze

      def extract_confirmable_id(headers)
        return if (tuple = headers.detect { |key, value| POSSIBLE_CONFIRMABLE_HEADERS.include?(key) && value.present? }).nil?

        tuple.last.split('/').last
      end
    end
  end
end
