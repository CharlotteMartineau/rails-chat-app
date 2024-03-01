class MessageSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :chatroom_id,
             :content,
             :created_at,
             :updated_at
end
