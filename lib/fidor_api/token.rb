module FidorApi

  class Token
    include ActiveModel::Model

    attr_accessor :access_token, :expires_at, :token_type, :refresh_token, :state

    def valid?
      expires_at >= Time.now
    end

    def expires_in=(value)
      self.expires_at = Time.now + value.seconds
    end

    def to_hash
      {
        access_token:  access_token,
        expires_at:    expires_at,
        token_type:    token_type,
        refresh_token: refresh_token,
        state:         state
      }
    end
  end

end
