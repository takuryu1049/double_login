# frozen_string_literal: true
class Companies::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  # URLで入力をこのコントローラーに向けて、ログイン状況に合わせて表示するビューを操作するメソッド(オーバライド)
  prepend_before_action :require_no_authentication, only: [:new]
  before_action :authentication_company_login, only: [:create]
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:name])
  # end
  
# URL直接入力した時のアクセス制限 new ログインが表示までの処理
# URLで入力をこのコントローラーに向けて、ログイン状況に合わせて表示するビューを操作するメソッド(オーバライド)
# newアクションを対象
def require_no_authentication
  # 会社と社員がログインしている場合を一度判定。
  if company_signed_in? && worker_signed_in?
    # ログインしている社員が、ログインしている会社に所属しているなら、
    # アプリTOPページへ飛ばす。
    if current_company.id == current_worker.company_id
      redirect_to top_path and return
    else
      # 社員のログイン画面で、会社の社員でないと、
      # その会社のアプリにログインできない制限をかけているので、
      # ここにくることはありえないが、念の為のエラーハンドリングで
      # root_pathの処理を設定している。
      redirect_to root_path and return
    end
    # すでに会社のみログイン済であれば、社員登録画面へ行く。
  elsif company_signed_in?
    @worker = Worker.new
    
    flash[:notice] = "会社ログイン済。社員ログインが必要"
    redirect_to new_worker_session_path and return
  else
    return
  end
end


def authentication_company_login
  if company_signed_in? && worker_signed_in?
    if current_company.id == current_worker.company_id
      redirect_to top_path and return
    else
      redirect_to root_path and return
    end
  elsif company_signed_in?
    @worker = Worker.new
    flash[:notice] = "すでに会社ログイン済。"
    redirect_to new_worker_session_path and return
  else
    return
  end
end

  def after_sign_in_path_for(resource)
    new_worker_session_path(resource)
  end

  def after_sign_out_path_for(resource)
    root_path(resource)
  end 

end
