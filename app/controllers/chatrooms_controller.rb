class ChatroomsController < ApplicationController
  before_action :set_chatroom!, only: %i[show update]

  def index
    chatrooms = Chatroom.all

    render json: chatrooms, each_serializer: ChatroomSerializer, status: 200
  end

  def show
    render json: chatroom, serializer: ChatroomSerializer, include_members: true, status: 200
  end

  def create
    chatroom = Chatroom.new(chatroom_params)

    if chatroom.save
      render json: chatroom, serializer: ChatroomSerializer, include_members: true, status: 201
    else
      render_error(code: 'CAN_NOT_CREATE_CHATROOM',
                   message: "Can not create chatroom : #{chatroom.errors.full_messages}", status: 400)
    end
  end

  def update
    if chatroom.update(chatroom_params)
      render json: chatroom, serializer: ChatroomSerializer, include_members: true, status: 200
    else
      render_error(code: 'CAN_NOT_UPDATE_CHATROOM',
                   message: "Can not update chatroom : #{chatroom.errors.full_messages}", status: 400)
    end
  end

  private

  def chatroom
    @chatroom ||= Chatroom.where(id: params[:id]).first
  end

  def chatroom_params
    params.require(:chatroom).permit(:name)
  end

  def set_chatroom!
    return if chatroom

    render_error(code: 'CANNOT_FIND_CHATROOM', message: 'Can not find chatroom',
                 status: 404)
  end
end
