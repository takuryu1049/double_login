# frozen_string_literal: true

class Workers::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :authenticate
  # before_action :configure_account_update_params, only: [:update]
def new
  @worker = Worker.new
end
# super消さないと何故かログインできない、super理解できてないから分からない。
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # # POST /resource
  def create
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def authenticate
    redirect_to root_path unless company_signed_in?
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:worker_id, :name, :gender, :company_id])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:worker_id, :name, :gender])
  # end

  # The path used after sign up.
  # この記述は登録後にアプリTOPへ遷移することを意味している。
  # 他にURL指定の場合には親コントローラーで定義されていて、rootへ遷移する。
  def after_sign_up_path_for(resource)
    top_path(resource)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end


  # 下記
  # 会社と社員がログインしている時に社員ログイン画面にログインしたらtop(ホーム)
  # def after_sign_in_path_for(resource)
  #   if company_signed_in? == worker_signed_in?
  #     top_path(resource)
  #     # 会社だけがログインしている状態なら、社員登録画面へ
  #   elsif company_signed_in?
  #     new_worker_registration_path(resource)
  #   end
  # end

end

