class ChatroomSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :members, serializer: MemberSerializer, if: -> { instance_options[:include_members] }
end
