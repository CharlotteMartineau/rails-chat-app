class JsonWebToken
  def self.encode(payload)
    JWT.encode(payload, ENV['JWT_SECRET_KEY'])
  end

  def self.decode(token)
    decoded = JWT.decode(token, ENV['JWT_SECRET_KEY'])[0]
    HashWithIndifferentAccess.new decoded
  end
end
