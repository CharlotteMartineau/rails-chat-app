class MemberSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :chatroom_memberships_id

  def chatroom_memberships_id
    object.chatroom_memberships.first.id
  end
end
