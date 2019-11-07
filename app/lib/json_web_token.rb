class JsonWebToken
  ALGORITHM = 'HS256'
  SECRET = Rails.application.secret_key_base

  class << self
    def encode(payload, exp=nil)
      payload[:exp] = exp.to_i if exp
      JWT.encode(payload, SECRET, ALGORITHM)
    end

    def decode(token)
      body = JWT.decode(token, SECRET, ALGORITHM)[0]
      HashWithIndifferentAccess.new body
    rescue
      Hash.new
    end
  end
end
