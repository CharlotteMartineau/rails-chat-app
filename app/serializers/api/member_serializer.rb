module Api
  class MemberSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name
  end
end
