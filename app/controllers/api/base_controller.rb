class Api::BaseController < ActionController::API
  include Devise::Controllers::Helpers

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def authenticate_user!
    render json: { error: { message: t("api.errors.unauthorized") } }, status: :unauthorized unless current_user
  end

  def render_not_found
    render json: { error: { message: t("api.errors.not_found") } }, status: :not_found
  end
end