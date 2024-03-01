class MessagesController < ApplicationController
  before_action :set_chatroom!, only: %i[create]

  def create
    message = @current_user.messages.new(message_params)

    if message.save
      render json: message, serializer: MessageSerializer, status: 201
    else
      render_error(code: 'CAN_NOT_CREATE_MESSAGE',
                   message: "Can not create message : #{message.errors.full_messages}", status: 400)
    end
  end

  def destroy
    message = @current_user.messages.where(id: params[:id]).first
    if message
      if message.destroy
        render json: { message_id: message.id }, status: 200

      else
        render_error(code: 'CAN_NOT_DELETE_MESSAGE',
                     message: "Can not delete message : #{message.errors.full_messages}", status: 400)
      end
    else
      render_unauthorized
    end
  end

  private

  def message_params
    params.permit(:content, :chatroom_id)
  end

  def chatroom
    @current_user.memberships.find_by(id: params[:chatroom_id])
  end

  def set_chatroom!
    return if chatroom

    render_unauthorized
  end

  def render_unauthorized
    render_error(code: 'UNAUTHORIZED', message: 'Unauthorized',
                 status: 401)
  end
end
