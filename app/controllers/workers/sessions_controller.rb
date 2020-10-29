# frozen_string_literal: true

class Workers::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
    prepend_before_action :require_no_authentication, only: [:new]
    before_action :authenticate_worker_login, only:[:create]
  # GET /resource/sign_in
  def new
    @worker = Worker.new
  end

  # POST /resource/sign_in
  def create
    super
    flash[:notice] = "ログインしました！"
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected
  
  # 会社がログインしていなければ、
  # 紹介ページへ返す。
  # def authenticate
  #     redirect_to root_path unless company_signed_in?
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:worker_id, :name, :gender, :company_id])
  # end
  # サインインした後と、サインイン後のURL指定の挙動
  # def after_sign_in_path_for(resource)
  #   if company_signed_in? && worker_signed_in?
  #     top_path(resource)
  #   else
  #     root_path(resource)
  #   end
  # end

# URL直接入力した時のアクセス制限 new ログインが表示までの処理
# URLで入力をこのコントローラーに向けて、ログイン状況に合わせて表示するビューを操作するメソッド(オーバライド)
# newアクションを対象
  def require_no_authentication
    # 会社と社員がログインしている場合を一度判定。
    if company_signed_in? && worker_signed_in?
      # ログインしている社員が、ログインしている会社に所属しているなら、アプリTOPページへ飛ばす。
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
      render :new  and return
    else
      redirect_to root_path and return
    end
  end

  # ログインする前の処理
  def authenticate_worker_login
    # アクションを起こす前(ログイン処理をする前に)emailを元に、
    # 社員の登録情報を取得する。ちなみにcurrent_worker.idではログインしていないので取得できない。emailではない場合は違うカラムを用意する。
    # また、paramsの動きが変わっていたので、型に合わせて、
    # 取得方法を入れ替えている。
    if params.class ==  ActionController::Parameters
      email_params = params[:worker][:email]
    else
      email_params = params[:email]
    end
    @worker = Worker.find_by(email: email_params) 
    # 社員情報が登録されているか判定する
    if @worker
      # 「会社でログイン」かつ「ログインしている会社のID」と「ログインしている社員の会社のID」が一致する場合には、処理を抜け、ログイン処理を行う。
      if company_signed_in? && current_company.id == @worker.company_id
        return
        # 違う会社の社員であれば、エラーハンドリングを行えるようにして、
        # ログイン画面にレンダリングを行う。 and returnでエラー防止。
        # @で入力値を保管していない為注意が必要。
      elsif company_signed_in? && current_company.id != @worker.company_id
        flash.now[:notice] = "他社社員です。(該当する社員情報はありません！)"
        @worker = Worker.new(email: email_params)
        render :new and return
      end
    else
      # 社員登録情報が見つからない場合には、
      # 入力情報を保持させるためにemailのみを持ったインスタンスを作成して、
      # エラーハンドリング表示を行えるようにする
      @worker = Worker.new(email: email_params)
      flash.now[:notice] = "社員情報が間違えています"
      render :new and return
    end
  end

  # ログイン後の遷移先
  def after_sign_in_path_for(resource)
    top_path(resource)
   end

  # ログアウト後の遷移先
  def after_sign_out_path_for(resource)
    new_worker_session_path(resource)
  end
  
end
