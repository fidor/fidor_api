# FidorApi

[![Gem Version](https://badge.fury.io/rb/fidor_api.svg)](https://badge.fury.io/rb/fidor_api)
[![Build Status](https://travis-ci.org/klausmeyer/fidor_api.svg?branch=master)](https://travis-ci.org/klausmeyer/fidor_api)
[![Test Coverage](https://codeclimate.com/github/klausmeyer/fidor_api/badges/coverage.svg)](https://codeclimate.com/github/klausmeyer/fidor_api/coverage)
[![Code Climate](https://codeclimate.com/github/klausmeyer/fidor_api/badges/gpa.svg)](https://codeclimate.com/github/klausmeyer/fidor_api)

Simple ruby client for the Fidor Bank REST-API: http://docs.fidor.de

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fidor_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fidor_api

## Usage

### 0. Configure

```ruby
FidorApi.configure do |config|
  config.oauth_url       = ENV["FIDOR_OAUTH_URL"]
  config.api_url         = ENV["FIDOR_API_URL"]
  config.callback_url    = ENV["FIDOR_API_CALLBACK"]
  config.client_id       = ENV["FIDOR_API_CLIENT_ID"]
  config.client_secret   = ENV["FIDOR_API_CLIENT_SECRET"]
  config.htauth_user     = ENV["FIDOR_API_HTAUTH_USER"]
  config.htauth_password = ENV["FIDOR_API_HTAUTH_PASSWORD"]
  config.affiliate_uid   = ENV["FIDOR_API_AFFILIATE_UID"]
end
```

### 1. oAuth (Rails)

Redirect the user to the authorize URL:

```ruby
redirect_to FidorApi::Auth.authorize_url
```

Use code passed to the callback URL and fetch the access token:

```ruby
session[:api_token] = FidorApi::Auth.fetch_token(params[:code]).to_hash
```

Renew token after it has expired:

```ruby
def api_token
  FidorApi::Token.new session[:api_token] if session[:api_token]
end

if api_token && !api_token.valid?
  session[:api_token] = FidorApi::Auth.refresh_token(api_token).to_hash
end
```

### 2. Fetching data

```ruby
FidorApi::Connectivity.access_token = "f859032a6ca0a4abb2be0583b8347937"

user = FidorApi::User.current
# => FidorApi::User

transactions = FidorApi::Transaction.all
# => FidorApi::Collection

transaction = transactions.first
# => FidorApi::Transaction
```

### 3. Creating transfers

```ruby
FidorApi::Connectivity.access_token = "f859032a6ca0a4abb2be0583b8347937"

transfer = FidorApi::Transfer::Internal.new(
  account_id:   875,
  receiver:     "kycfull@fidor.de",
  external_uid: "4279762F5",
  subject:      "Money for you",
  amount:       1000
)
# => FidorApi::Transfer::Internal

transfer.save
# => true
# or
# => false and `transfer.errors` containing details
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/klausmeyer/fidor_api.

## Changelog

Have a look at the [CHANGELOG](CHANGELOG.md) for details.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
