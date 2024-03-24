module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      decoded_token = JWT.decode(token, ENV['JWT_SECRET_KEY'])[0]
      user_id = decoded_token['user_id']
      query = User.where(id: user_id)

      if (verified_user = query.first)
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def token
      cookies && cookies['X-Authorization']
    end
  end
end
