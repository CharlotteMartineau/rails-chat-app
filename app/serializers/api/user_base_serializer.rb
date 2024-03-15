module Api
  class UserBaseSerializer < ActiveModel::Serializer
    attributes :id,
               :first_name,
               :last_name,
               :email

    attribute :token, if: -> { instance_options[:include_token] }
    # call the token method in User model if include_token is true in the controller

    def first_name
      object.first_name&.humanize
    end

    def last_name
      object.last_name&.humanize
    end
  end
end
