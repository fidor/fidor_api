module FidorApi
  module Connectivity
    class Endpoint
      attr_reader :collection, :resource, :version

      def initialize(path, mode, version: '1')
        @path = path
        @version = version

        case mode
        when :collection
          @collection = path
          @resource = "#{path}/:id"
        when :resource
          @resource = path
        else
          fail ArgumentError, "mode #{mode.inspect} must be resource or collection"
        end
      end

      class Context
        def initialize(endpoint, object)
          @endpoint = endpoint
          @object = object
        end

        def get(target: :resource, action: nil, query_params: nil)
          Connection.get(send("#{target}_path", action), query_params: query_params, version: @endpoint.version)
        end

        def post(target: :collection, action: nil, payload: nil)
          Connection.post(send("#{target}_path", action), body: payload, version: @endpoint.version)
        end

        def put(target: :resource, action: nil, payload: nil)
          Connection.put(send("#{target}_path", action), body: payload, version: @endpoint.version)
        end

        def delete(target: :resource, action: nil)
          Connection.delete(send("#{target}_path", action), version: @endpoint.version)
        end

        private

        def resource_path(action = nil)
          interpolate(@endpoint.resource, action)
        end

        def collection_path(action = nil)
          interpolate(@endpoint.collection, action)
        end

        def interpolate(path, suffix = nil)
          [path, suffix].compact.join('/').gsub(/:(\w+)/) do |m|
            fetch_option $1
          end
        end

        def fetch_option(name)
          if @object.kind_of? Hash
            @object[name]
          elsif @object.kind_of?(Fixnum) || @object.kind_of?(String)
            @object
          elsif @object.respond_to? name
            @object.public_send name
          end
        end
      end

      def for(object)
        Context.new(self, object)
      end
    end
  end
end
