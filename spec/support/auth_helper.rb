module AuthHelper
  def stub_oauth_auth_code_request
    stub_request(:post, %r{/oauth/token})
      .with(body: {
        grant_type:   'authorization_code',
        client_id:    client_id,
        redirect_uri: redirect_uri,
        code:         '9999'
      }.to_json).to_return(valid_token_response)
  end

  def stub_oauth_password_request
    stub_request(:post, %r{/oauth/token})
      .with(body: {
        grant_type: 'password',
        username:   username,
        password:   password
      }.to_json).to_return(valid_token_response)
  end

  def stub_oauth_client_request
    stub_request(:post, %r{/oauth/token})
      .with(body: { grant_type: 'client_credentials' }.to_json)
      .to_return(valid_token_response)
  end

  def valid_token_response
    {
      status:  200,
      headers: { 'Content-Type' => 'application/json' },
      body:    {
        access_token:  'access-token',
        expires_in:    900,
        token_type:    'Bearer',
        refresh_token: 'refresh-token'
      }.to_json
    }
  end
end
