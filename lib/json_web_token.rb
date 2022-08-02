class JsonWebToken
  SECRET_KEY = ENV['SECRET_KEY_BASE']

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    begin
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    rescue Exception => e
      e.to_s
    end
  end

  def self.encode_secret(payload, secret, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret)
  end

  def self.decode_secret(token, secret)
    begin
      decoded = JWT.decode(token, secret)[0]
      HashWithIndifferentAccess.new decoded
    rescue Exception => e
      e.to_s
    end
  end
end