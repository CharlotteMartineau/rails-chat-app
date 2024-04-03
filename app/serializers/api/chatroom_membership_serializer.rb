module Api
  class ChatroomMembershipSerializer < ActiveModel::Serializer
    attributes :id, :user_id, :member

    def member
      MemberSerializer.new(User.where(id: object.user_id).first).attributes
    end
  end
end
