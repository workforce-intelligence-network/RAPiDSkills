class ClientSession < ApplicationRecord
  belongs_to :user

  def token
    JsonWebToken.encode(authentication_payload)
  end

  private

  def authentication_payload
    {
      id: user_id,
      encrypted_password: user.encrypted_password,
      session_identifier: identifier,
    }
  end
end
