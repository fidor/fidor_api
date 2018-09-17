require 'spec_helper'

module FidorApi
  module Environment
    RSpec.describe Base do
      let(:instance) { described_class.new }

      describe 'methods to be implemented in subclasses' do
        it 'raises an error if they are called' do
          %i[api_host auth_host auth_redirect_host auth_methods].each do |method|
            expect { instance.public_send(method) }.to raise_error NotImplementedError
          end
        end
      end
    end
  end
end
