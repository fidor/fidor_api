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

    describe '#save failure with a 422 status' do
      before do
        FidorApi::Connectivity::Resource::ROUTING_INFO_ERROR_PREFIX = "routing."
        WebMock.stub_request(:put, "https://aps.fidor.de/resource").
          to_return(
            body: '{"code":422,"errors":[{"field":"type","message":"code invalid"}],"message":"Not valid","key":["code_suspended"]}',
            status: 422
          )
      end

      it 'includes the key in the error keys' do
        model.save
        expect(model.error_keys.first).to eq('code_suspended')
      end
    end

    describe '#save failure with a 500 status' do
      before do
        WebMock.stub_request(:put, "https://aps.fidor.de/resource").to_return(body: 'Internal server error', status: 500)
      end

      it 'raises a ClientError' do
        expect do
          model.save
        end.to raise_error(FidorApi::ClientError, "Internal server error")
      end
    end
  end
end
