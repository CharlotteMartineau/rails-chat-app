module Api
  class ChatroomSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :chatroom_memberships, serializer: ChatroomMembershipSerializer
    has_many :messages, if: -> { instance_options[:include_messages] }
  end
end
