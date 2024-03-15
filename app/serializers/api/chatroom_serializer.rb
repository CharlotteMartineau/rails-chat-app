module Api
  class ChatroomSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :members, serializer: MemberSerializer, if: -> { instance_options[:include_members] }
    has_many :messages, if: -> { instance_options[:include_messages] }
  end
end
