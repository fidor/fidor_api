module FidorApi
  module Connectivity
    class Endpoint
      attr_reader :collection, :resource, :version, :tokenless

      def initialize(path, mode, version: '1', tokenless: false)
        @path = path
        @version = version
        @tokenless = tokenless

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

        def get(target: :resource, action: nil, query_params: nil, tokenless: nil)
          request :get, target, action, query_params: query_params, tokenless: tokenless
        end

        def post(target: :collection, action: nil, payload: nil, tokenless: nil)
          request :post, target, action, body: payload, tokenless: tokenless
        end

        def put(target: :resource, action: nil, payload: nil, tokenless: nil)
          request :put, target, action, body: payload, tokenless: tokenless
        end

        def delete(target: :resource, action: nil, tokenless: nil)
          request :delete, target, action, tokenless: tokenless
        end

        private

        def request(method, target, action, options = {})
          options.reverse_merge! version: @endpoint.version
          options[:access_token] = nil if options[:tokenless] || @endpoint.tokenless
          Connection.public_send(method, send("#{target}_path", action), options)
        end

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
          elsif @object.class.name.in?(INTEGER_CLASSES) || @object.kind_of?(String)
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
