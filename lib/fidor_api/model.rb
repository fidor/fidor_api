module FidorApi
  module Model
    autoload :Account,           'fidor_api/model/account'
    autoload :Base,              'fidor_api/model/base'
    autoload :Card,              'fidor_api/model/card'
    autoload :ConfirmableAction, 'fidor_api/model/confirmable_action'
    autoload :Customer,          'fidor_api/model/customer'
    autoload :Helpers,           'fidor_api/model/helpers'
    autoload :Message,           'fidor_api/model/message'
    autoload :Preauth,           'fidor_api/model/preauth'
    autoload :Transaction,       'fidor_api/model/transaction'
    autoload :Transfer,          'fidor_api/model/transfer'
    autoload :User,              'fidor_api/model/user'
  end
end
