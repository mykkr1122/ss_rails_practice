class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:create]

  # POST /api/v1/login
  # メールアドレス・パスワードを検証し、成功時はAuthorizationヘッダーにJWTを発行する。
  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      sign_in(user)
      render json: { user: { id: user.id, email: user.email, name: user.name } }, status: :ok
    else
      render json: { error: { message: t("api.errors.invalid_credentials") } }, status: :unauthorized
    end
  end

  # DELETE /api/v1/logout
  # 現在のJWTを失効させる。
  def destroy
    sign_out(current_user)
    head :no_content
  end
end
