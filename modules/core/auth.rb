module Core
  class Auth
    def self.authenticate!(headers, _ip)
      return false if headers.blank?

      begin
        token             = headers.gsub('Bearer ', '')
        result            = JWT.decode(token, ENV['SECRET_KEY_BASE'], true, { algorithm: 'HS256' })
        @user_id          = result[0]['user_id']
        @expired_at       = result[0]['exp']
        true
      rescue JWT::DecodeError
        nil
      end
    end

    def self.user
      @expired_at < Time.now.to_i ? @user_id = nil : @user_id
    end
  end
end
