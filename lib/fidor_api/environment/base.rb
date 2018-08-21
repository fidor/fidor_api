module FidorApi
  module Environment
    class Base
      def api_host
        raise NotImplementedError
      end

      def auth_host
        raise NotImplementedError
      end

      def auth_methods
        raise NotImplementedError
      end

      def transfers_api
        raise NotImplementedError
      end
    end
  end
end
