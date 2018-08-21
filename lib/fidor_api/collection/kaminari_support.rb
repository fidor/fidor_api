module FidorApi
  class Collection
    module KaminariSupport
      def last_page?
        current_page == total_pages
      end

      def next_page
        current_page + 1
      end

      def limit_value
        per_page
      end
    end
  end
end
