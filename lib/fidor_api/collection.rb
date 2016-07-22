module FidorApi

  class Collection
    include ActiveModel::Model
    include Enumerable

    attr_accessor :records
    attr_accessor :total_pages, :current_page, :limit_value, :total_entries

    def self.build(klass, response)
      new.tap do |object|
        data       = response["data"]
        collection = response["collection"]

        object.records = data.map { |record| klass.new(record) }

        object.total_pages   = collection["total_pages"]
        object.current_page  = collection["current_page"]
        object.limit_value   = collection["per_page"]
        object.total_entries = collection["total_entries"]
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
  end

end