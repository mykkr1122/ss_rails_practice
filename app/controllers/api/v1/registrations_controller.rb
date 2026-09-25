class Api::V1::RegistrationsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:create]

  # POST /api/v1/account
  # 新規アカウントを作成し、そのままログイン状態にしてJWTを発行する。
  def create
    user = User.new(account_params)
    if user.save
      sign_in(user)
      render json: { user: { id: user.id, email: user.email, name: user.name } }, status: :created
    else
      render json: { error: { messages: user.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/account
  # 自分のアカウント情報を更新する。current_passwordの一致が必須。
  def update
    if current_user.update_with_password(account_params)
      render json: { user: { id: current_user.id, email: current_user.email, name: current_user.name } }
    else
      render json: { error: { messages: current_user.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end
