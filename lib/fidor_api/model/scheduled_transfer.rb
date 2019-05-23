module FidorApi
  module Model
    class ScheduledTransfer < Model::Base
      attribute :id,   :string
      attribute :account_id, :integer
      attribute :external_uid, :string
      attribute :amount, :float
      attribute :currency, :string
      attribute :subject, :string
      attribute :status, :string
    end
  end
end
