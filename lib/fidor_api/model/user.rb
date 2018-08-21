module FidorApi
  module Model
    class User < Base
      attribute :id,            :integer
      attribute :email,         :string
      attribute :affiliate_uid, :string
      attribute :msisdn,        :string
    end
  end
end
