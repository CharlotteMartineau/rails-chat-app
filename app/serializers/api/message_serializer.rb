module Api
  class MessageSerializer < ActiveModel::Serializer
    attributes :id,
               :user_id,
               :chatroom_id,
               :content,
               :created_at,
               :updated_at,
               :user_first_name,
               :user_last_name

    def user_first_name
      User.find(object.user_id).first_name
    end

    def user_last_name
      User.find(object.user_id).last_name
    end
  end
end
