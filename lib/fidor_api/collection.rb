module FidorApi
  class Collection
    autoload :KaminariSupport, 'fidor_api/collection/kaminari_support'

    include Enumerable
    include KaminariSupport

    attr_reader \
      :current_page,
      :per_page,
      :total_entries,
      :total_pages

    def initialize(klass:, raw:)
      @current_page  = raw.fetch('collection').fetch('current_page')
      @per_page      = raw.fetch('collection').fetch('per_page')
      @total_entries = raw.fetch('collection').fetch('total_entries')
      @total_pages   = raw.fetch('collection').fetch('total_pages')
      @records       = raw.fetch('data').map { |attributes| klass.new(attributes) }
    end

    def each(&block)
      records.each(&block)
    end

    private

    attr_reader :records
  end
end
