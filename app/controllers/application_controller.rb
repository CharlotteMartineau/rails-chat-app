class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :allow_cors
  before_action :authorize_request, except: %i[options check]

  def allow_cors
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = %w[GET POST PUT PATCH DELETE].join(',')
    headers['Access-Control-Allow-Headers'] =
      %w[Origin Accept Content-Type X-Requested-With X-CSRF-Token Authorization].join(',')
  end

  def check
    render json: { status: :ok }
  end

  def render_error(code:, message:, status:)
    render json: { "error": { "code": code, "message": message, "status": status } }, status:
  end

  def authorize_request
    bearer = request.env['Authorization'] || request.env['HTTP_AUTHORIZATION'] || params[:token]
    token = bearer.split(' ').last if bearer
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render_error(code: 'UNAUTHORIZED', message: e.message, status: 401)
    rescue JWT::DecodeError => e
      render_error(code: 'UNAUTHORIZED', message: e.message, status: 401)
    end
  end
end
