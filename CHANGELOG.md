# Changelog

## Next version (not yet released)

* Nothing at the moment :)

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
