class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :set_user!, only: %i[show update destroy]
  before_action :check_current_user_is_user!, only: %i[show update destroy]

  def index
    users = User.all

    render json: users,
           each_serializer: UserBaseSerializer,
           status: 200
  end

  def show
    render json: user, serializer: UserBaseSerializer, status: 200
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, serializer: UserBaseSerializer, status: 201
    else
      render_error(code: 'CAN_NOT_CREATE_USER', message: "Can not create user : #{user.errors.full_messages}",
                   status: 400)
    end
  end

  def update
    if user.update(user_params)
      render json: user, serializer: UserBaseSerializer, status: 200
    else
      render_error(code: 'CAN_NOT_UPDATE_USER', message: "Can not update user : #{user.errors.full_messages}",
                   status: 400)
    end
  end

  def destroy
    if user.destroy
      render json: User.all, each_serializer: UserBaseSerializer, status: 200
    else
      render_error(code: 'CAN_NOT_DELETE_USER', message: "Can not delete user : #{user.errors.full_messages}",
                   status: 400)
    end
  end

  private

  def user
    @user ||= User.where(id: params[:id]).first
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def set_user!
    return if user

    render_error(code: 'CANNOT_FIND_USER', message: 'Can not find user',
                 status: 404)
  end

  def check_current_user_is_user!
    return if user.id == @current_user.id

    render_error(code: 'USER_UNAUTHORIZED', message: 'Unauthorized user',
                 status: 401)
  end
end
