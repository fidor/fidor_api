module FidorApi

  class Client
    include ActiveModel::Model

    attr_accessor :token

    include Account::ClientSupport
    include Beneficiary::ClientSupport
    include Card::ClientSupport
    include CardLimits::ClientSupport
    include ConfirmableAction::ClientSupport
    include Customer::ClientSupport
    include Message::ClientSupport
    include Preauth::ClientSupport
    include SessionToken::ClientSupport
    include Transaction::ClientSupport
    include Transfer::ACH::ClientSupport
    include Transfer::Internal::ClientSupport
    include Transfer::SEPA::ClientSupport
    include Transfer::FPS::ClientSupport
    include Transfer::P2pPhone::ClientSupport
    include Transfer::P2pUsername::ClientSupport
    include User::ClientSupport
  end

end
