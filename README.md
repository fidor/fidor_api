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

Examples:

1. oAuth

```ruby
todo
```

2. Fetching data

```ruby
token = FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937")

client = FidorApi::Client.new(token: token)
user = client.current_user
# => FidorApi::User

transactions = client.transactions
# => FidorApi::Collection

transaction = transactions.first
# => FidorApi::Transaction
```

3. Creating transfers

```ruby
token = FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937")

client = FidorApi::Client.new(token: token)

transfer = client.build_internal_transfer(
  account_id:   875,
  receiver:     "kycfull@fidor.de",
  external_uid: "4279762F5",
  subject:      "Money for you",
  amount:       1000
)
# => FidorApi::Transfer::Internal

transfer.save
# => true / or raise error
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/klausmeyer/fidor_api.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

