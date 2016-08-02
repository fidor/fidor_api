# Changelog

## Next version (not yet released)

* Also map errors returned on the `:base` field
* Support for `/transfers` endpoint with `routing_type` "ACH" (*Note*: Not supported in fidor.de & fidorbank.uk APIs)
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
