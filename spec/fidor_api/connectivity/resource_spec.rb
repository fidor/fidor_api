require "spec_helper"

module FidorApi
  class DummyResource < Connectivity::Resource
    extend ModelAttribute

    self.endpoint = Connectivity::Endpoint.new('/resource', :resource)

    attribute :id,   :string
    attribute :foo,  :string
    attribute :bar,  :string
  end

  describe Connectivity::Resource do
    let(:model) { DummyResource.new(id: 1001, foo: 'foo', bar: 'bar') }

    before do
      FidorApi::Connectivity.access_token = 'f859032a6ca0a4abb2be0583b8347937'
      WebMock.stub_request(:put, "https://aps.fidor.de/resource")
    end

    describe '#update_attributes' do
      it 'updates those attributes' do
        model.update_attributes(foo: 'foo2')
        expect(model.foo).to eq('foo2')
        expect(WebMock).to have_requested(:put, /\/resource$/)
          .with { |req| req.body == '{"foo":"foo2"}' }
          .once
      end
    end
  end
end
