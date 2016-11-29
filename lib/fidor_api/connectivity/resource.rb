module FidorApi
  module Connectivity
    class Resource
      include ActiveModel::Model
      extend ModelAttribute

      class_attribute :endpoint

      attr_accessor :error_keys

      class << self
        def find(id)
          new endpoint.for(id).get.body.reverse_merge(id: id)
        end

        def all(options = {})
          FidorApi::Collection.build self, endpoint.for(self).get(target: :collection, query_params: options).body
        end

        def model_name
          ActiveModel::Name.new(self, nil, self.name.sub("FidorApi::", ""))
        end
      end

      def initialize(attributes = {})
        set_attributes attributes
      end

      def reload
        set_attributes endpoint.for(self).get.body
      end

      def persisted?
        id.present?
      end

      def save
        if valid?
          set_attributes(persisted? ? remote_update.body : remote_create.body)
          true
        else
          false
        end
      rescue ValidationError => e
        self.error_keys = e.error_keys
        map_errors(e.fields)
        false
      end

      def update_attributes(attributes={})
        set_attributes attributes
        valid? and remote_update attributes.keys
      end

      private

      def remote_create
        endpoint.for(self).post(payload: self.as_json)
      end

      def remote_update(*attributes)
        payload = self.as_json.with_indifferent_access
        payload.slice!(*attributes.flatten) if attributes.present?
        endpoint.for(self).put(payload: payload)
      end

      def map_errors(fields)
        fields.each do |hash|
          hash.symbolize_keys!
          field = hash[:field].to_sym
          errors.add(field, hash[:message], hash) if respond_to?(field) || field == :base
        end
      end
    end
  end
end
