module FidorApi
  module Model
    class ConfirmableAction < Base
      attribute :id,   :string
      attribute :type, :string
      attribute :otp,  :string
    end
  end
end
