
# ここには特に制限かけてないので、実際の開発ではしっかり制限をかけてください。

class HomeController < ApplicationController
  # before_action :authenticate_same_home, except: [:index]
  def index
  end

  def index_home
  end

private

# def authenticate_same_home
#   if  company_signed_in? && worker_signed_in? && current_worker.company_id == current_company.id
#     return
#       # ログインしている会社と違う会社の社員ログインがあった際に、
#       # 強制ログアウト処理をしているが、この制限がなければログインできるが、
#       # 便宜上後で、●●株式会社に該当社員の登録がありません。と出力させる。
#       # renderで専用のテンプレートを返してもいいかもしれない。
#   elsif company_signed_in?
#     redirect_to new_worker_session_path
#   else
#     redirect_to root_path
#   end


end
