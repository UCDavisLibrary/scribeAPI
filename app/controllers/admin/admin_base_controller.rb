class Admin::AdminBaseController < ApplicationController

  # LD: remove auth checks for now
  before_action :check_admin_user, except: :signin

  def index
    redirect_to admin_dashboard_path
  end

  def check_admin_user
    # LD: No auth checks right now
    #if current_user.nil? || ! current_user.can_view_admin?
    #  session[:login_redirect] = request.fullpath
    #  redirect_to admin_signin_path
    #end
  end
end
