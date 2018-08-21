module FidorApi
  module Model
    module Transfer
      module Classic
        autoload :Base,     'fidor_api/model/transfer/classic/base'
        autoload :Internal, 'fidor_api/model/transfer/classic/internal'
        autoload :SEPA,     'fidor_api/model/transfer/classic/sepa'
      end
    end
  end
end
