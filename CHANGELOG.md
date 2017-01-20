# Changelog

## v0.1.0

With this release this gem will start following the semantic versioning approach.

**Note**: This version contains two major changes which will break existing applications:

### How to initiate the client:

Before:

```ruby
client = FidorApi::Client.new(token: FidorApi::Token.new(access_token: "f859032a6ca0a4abb2be0583b8347937"))
```

After:

```
FidorApi::Connectivity.access_token = "f859032a6ca0a4abb2be0583b8347937"
```

### How to create resources:

Before:

```ruby
transfer = client.build_internal_transfer(
  account_id:   875,
  receiver:     "kycfull@fidor.de",
  external_uid: "4279762F5",
  subject:      "Money for you",
  amount:       1000
)
transfer.save
```

After:

```ruby
transfer = FidorApi::Transfer::Internal.new(
  account_id:   875,
  receiver:     "kycfull@fidor.de",
  external_uid: "4279762F5",
  subject:      "Money for you",
  amount:       1000
)
transfer.save
```

* Also map errors returned on the `:base` field
* Support for `/transfers` and `/beneficiaries` endpoints` with routing types: (*Note*: Not supported in fidor.de & fidorbank.uk APIs)
  * `ACH`
  * `BANK_INTERNAL`
  * `FOS_P2P_ACCOUNT_NUMBER`
  * `FOS_P2P_PHONE`
  * `FOS_P2P_USERNAME`
  * `SWIFT`
  * `UTILITY`
* Improve logger setup
  * Add new `logger` config option to pass existing logger
  * Add support for `faraday-detailed_logger` gem without adding additional dependency
* Support for `/confirmable/actions` endpoint
* New option `verify_ssl` (needed when testing against e.g. mock-services or fidor-internal test installations)
* Logging for `FidorApi::ClientError` cases
* New fields for contact- & bank-details in `/transfers` endpoint
* Support for `/session_tokens` endpoint
* Support for `/beneficiaries` endpoint
* Provide `total_entries` attribute in collections
* Support for `/messages/:id/content` endpoint
* Support for updating customer records
* New fields for customer endpoint
* Support Address attribute in cards endpoint
* Handle HTTP 303 with exception indicating the need to use confirmable-action
* Add unique_name attribute to beneficiaries
* Add support to activate and cancel cards
* Better mapping of error keys to support usage of i18n
* Suport for endpoints to reset & change password
* New way to build ressources (using `FidorApi::Transfers::ACH.new` instead of `client.build_ach_transfer`)
* Allow to update customers
* Improved Ruby 2.4 compatibility

## v0.0.2

All commits: https://github.com/klausmeyer/fidor_api/compare/v0.0.1...v0.0.2

* Gem can now be used in rails 5 projects
* `FidorApi::Client` added to improve token-management
* `remote_bic` field optional in `Transfer::SEPA`
* Amounts are now `BigDecimal` type
* `Resource#model_name` returns `Resource` instead of `FidorApi::Resource` now
* Collection implements `Enumerable`
* `Resource#persisted?` added to improve `ActiveRecord` style behaviour
* `Customer#gender` now returns `FidorApi::Customer::Gender`
* Basic support for signup (`Msisdn`, `Customer#save`)
* Support new endpoints
  * `/cards`
  * `/card_limits`
  * `/messages`
  * `/fps_payments` (:gb: specific)
* Provide validation errors returned in API in `Resource#errors`

## v0.0.1

* First release on rubygems.org
* oAuth support
* Basic support for the following endpoints:
  * `/accounts`
  * `/customers`
  * `/preauths`
  * `/transactions`
  * `/internal_transfers`
  * `/sepa_credit_transfers`
  * `/users/current`
