module Api
  class SessionsController < Api::ApplicationController
    before_action :authorize_request, except: :login

    def login
      @user = User.find_by_email(user_params[:email])
      if @user&.authenticate(user_params[:password])
        render json: @user, serializer: Api::UserBaseSerializer, include_token: true, status: 200
      else
        render_error(code: 'UNAUTHORIZED', message: 'Could not authenticate user',
                     status: 401)
      end
    end

    private

    def user_params
      params.require(:user).permit(:email,
                                   :password)
    end
  end
end
