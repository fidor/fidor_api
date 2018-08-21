module FidorApi
  module Model
    class Base
      class << self
        def inherited(klass)
          klass.include ActiveModel::Model
          klass.include Helpers::ActionViewSupport

          klass.extend ModelAttribute
          klass.extend Helpers::AttributeDecimalMethods

          klass.define_method :initialize do |attributes = {}|
            set_attributes(attributes)
          end
        end

        def resource_name
          name.sub('FidorApi::Model::', '')
        end
      end

      attr_accessor :confirmable_action_id

      def as_json
        attributes.compact
      end

      def parse_errors(body) # rubocop:disable Metrics/AbcSize
        Array(body['errors']).each do |hash|
          field   = hash.delete('field').to_sym
          key     = hash.delete('key')

          next unless respond_to?(field) || field == :base

          if key
            errors.add(field, key.to_sym, hash.symbolize_keys)
          else
            errors.add(field, hash.delete('message'), hash.symbolize_keys)
          end
        end
      end
    end
  end
end
