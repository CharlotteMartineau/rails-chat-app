class ChatroomMembershipsController < ApplicationController
  before_action :set_chatroom!, only: %i[create destroy]

  def create
    users = User.where(id: params.require([:user_ids]))

    users.each do |user|
      chatroom.chatroom_memberships.create!(user:)
    end

    render json: chatroom, serializer: ChatroomSerializer, include_members: true, status: 201
  rescue ActiveRecord::RecordInvalid => e
    render_error(code: 'CAN_NOT_CREATE_CHATROOM_MEMBERSHIP',
                 message: "Can not create chatroom membership : #{e}", status: 400)
  end

  def destroy
    membership.destroy
    render json: chatroom, serializer: ChatroomSerializer, include_members: true, status: 200
  end

  private

  def chatroom
    @chatroom ||= Chatroom.where(id: params[:chatroom_id]).first
  end

  def membership
    @membership ||= ChatroomMembership.find(params[:id])
  end

  def set_chatroom!
    return if chatroom

    render_error(code: 'CANNOT_FIND_CHATROOM', message: 'Can not find chatroom',
                 status: 404)
  end
end
