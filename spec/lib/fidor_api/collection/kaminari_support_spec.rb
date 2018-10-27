module FidorApi
  class Collection
    RSpec.describe KaminariSupport do
      let(:collection) do
        Collection.new(klass: FidorApi::Model::User, raw: {
          'data'       => [],
          'collection' => {
            'current_page'  => current_page,
            'per_page'      => per_page,
            'total_entries' => total_entries,
            'total_pages'   => total_pages
          }
        })
      end

      let(:current_page)  { 1 }
      let(:per_page)      { 10 }
      let(:total_entries) { 1 }
      let(:total_pages)   { 1 }

      describe '#last_page?' do
        subject { collection.last_page? }

        context 'when the current page is the last one' do
          let(:current_page) { total_pages }

          it { is_expected.to be true }
        end

        context 'when the current page is not the last one' do
          let(:current_page) { total_pages - 1 }

          it { is_expected.to be false }
        end
      end

      describe '#next_page' do
        subject { collection.next_page }

        it { is_expected.to eq 2 }
      end

      describe '#limit_value' do
        subject { collection.limit_value }

        it { is_expected.to eq 10 }
      end
    end
  end
end
