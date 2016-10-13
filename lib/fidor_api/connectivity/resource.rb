module FidorApi
  module Connectivity
    class Resource
      include ActiveModel::Model
      extend ModelAttribute

      class_attribute :endpoint

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
        map_errors(e.fields)
        false
      end

      def update_attributes(attributes={})
        set_attributes attributes
        valid? and remote_update attributes.keys.map(&:to_s)
      end

      private

      def remote_create
        endpoint.for(self).post(payload: self.as_json)
      end

      def remote_update(attributes=nil)
        payload = self.as_json
        payload.slice!(*attributes) if attributes
        endpoint.for(self).put(payload: payload)
      end

      def map_errors(fields)
        fields.each do |hash|
          key = hash["field"].to_sym
          errors.add(hash["field"].to_sym, hash["message"]) if key == :base || respond_to?(key)
        end
      end
    end
  end
end
