module FidorApi

  class Client
    include ActiveModel::Model

    attr_accessor :token

    include Account::ClientSupport
    include Card::ClientSupport
    include CardLimits::ClientSupport
    include ConfirmableAction::ClientSupport
    include Customer::ClientSupport
    include Message::ClientSupport
    include Preauth::ClientSupport
    include Transaction::ClientSupport
    include Transfer::ACH::ClientSupport
    include Transfer::Internal::ClientSupport
    include Transfer::SEPA::ClientSupport
    include Transfer::FPS::ClientSupport
    include User::ClientSupport
  end

end
