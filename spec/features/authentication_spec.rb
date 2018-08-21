require 'spec_helper'

RSpec.describe 'Authentication' do
  let(:client)        { setup_client }
  let(:client_id)     { 'client-id' }
  let(:client_secret) { 'client-secret' }
  let(:redirect_uri)  { 'http://localhost:4000/auth/callback' }
  let(:username)      { 'api_tester@example.com' }
  let(:password)      { 'password' }

  context 'with Fidor DE environment' do
    let(:environment) { FidorApi::Environment::FidorDE::Sandbox.new }

    it 'does not support the login with username/password' do
      expect do
        client.login(
          username: username,
          password: password
        )
      end.to raise_error FidorApi::Errors::NotSupported
    end

    it 'does not support the client login' do
      expect { client.client_login }.to raise_error FidorApi::Errors::NotSupported
    end

    it 'supports the creation of an auth-code flow url' do
      url = client.authorize_start(
        redirect_uri: redirect_uri,
        state:        '1234'
      )

      expect(url).to eq "https://apm.sandbox.fidor.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{CGI.escape(redirect_uri)}&state=1234&response_type=code"
    end

    it 'supports the completion of an auth-code flow' do
      stub_oauth_auth_code_request

      token = client.authorize_complete(
        redirect_uri: redirect_uri,
        code:         '9999'
      )

      expect(token).to be_instance_of FidorApi::Token
      expect(token.access_token).to eq 'access-token'
    end
  end

  context 'with Future environment' do
    let(:environment) { FidorApi::Environment::Future.new }

    it 'supports the login with username/password' do
      stub_oauth_password_request

      token = client.login(
        username: username,
        password: password
      )

      expect(token).to be_instance_of FidorApi::Token
      expect(token.access_token).to eq 'access-token'
    end

    it 'supports the client login' do
      stub_oauth_client_request

      token = client.client_login

      expect(token).to be_instance_of FidorApi::Token
      expect(token.access_token).to eq 'access-token'
    end
  end
end
