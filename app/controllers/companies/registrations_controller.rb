# frozen_string_literal: true
# 会社登録のためのコントローラー
# 登録ページに行くアクションとデータ登録する時のアクションのみ
class Companies::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # def new
  #   @company = Company.new()
  # end

  # def create
  #   @company = Company.new(configure_sign_up_params)
  #   if @company.save
  #     redirect_to root_path
  #   else
  #     render :new
  #   end
  # end
  


  # GET /resource/sign_up
  def new
    super
  end
  # superを使うと何故かエラーになる ログイン状況でインした為。

  # POST /resource
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



  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides Recaptcha
      set_minimum_password_length
      respond_with resource
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.


  # def 
  #   if company_signed_in? && worker_signed_in?
  #     redirect_to top_path(resource)
  #   elsif company_signed_in?
  #     redirect_to new_worker_session_path(resource)
  #   end
  # end
  # 会社でログインしている状態で、(after_sign_up_path_for)
  # ※会社でログインしている状態で、会社登録画面へ遷移した時。
  # 会社登録ボタンを押した時の挙動。
  # ①会社ログイン済で社員がログインしているときは、
  # アプリのトップページへ飛ばす。
  # ②会社のみログイン済の場合には、
  # 社員ログイン画面へ飛ばす。
  # 登録ボタンを押した後と、押してログインした状態も含まれるのか？
  # 多分含まれている、後で確認する挙動は想像通り。

  # ★会社登録してログイン後の遷移先を社員登録画面へ指定。
  def after_sign_up_path_for(resource)
      new_worker_registration_path(resource)
  end
  


# 上記を設定したら、ログイン後のリダイレクト先を変更できた。
# なぜ変更できたのかは分からない。

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  
  # ★ログイン
  # def after_sign_in_path_for(resource)
  #   if company_signed_in? && worker_signed_in?
  #     top_path(resource)
  #   else
  #     new_worker_registration_path(resource)
  #   end
  # end

end
