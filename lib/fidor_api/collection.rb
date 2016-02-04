module FidorApi

  class Collection
    include ActiveModel::Model
    include Enumerable

    attr_accessor :records
    attr_accessor :total_pages, :current_page, :limit_value

    def self.build(klass, response)
      new.tap do |object|
        # NOTE: We need this ugly hack since the sandbox is not wrapping records into data key.
        # Will hopefully go away in future.
        if response.is_a? Hash
          data       = response["data"]
          collection = response["collection"]
        else
          data       = response
          collection = collection_from_array response
        end

        object.records      = data.map { |record| klass.new(record) }

        object.total_pages  = collection["total_pages"]
        object.current_page = collection["current_page"]
        object.limit_value  = collection["per_page"]
      end
    end

    def each(&block)
      records.each(&block)
    end

    # --- kaminari stuff -- maybe move somewhere else
    def last_page?
      current_page == total_pages
    end

    def next_page
      current_page + 1
    end

    private

    def self.collection_from_array(array)
      {
        "total_pages"  => 1,
        "current_page" => 1,
        "per_page"     => array.count
      }
    end
  end

end