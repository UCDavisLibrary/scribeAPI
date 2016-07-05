class Admin::AdminBaseController < ApplicationController

  # LD: remove auth checks for now
#  before_action :check_admin_user, except: :signin

  def index
    redirect_to admin_dashboard_path
  end

  def check_admin_user
    if current_user.nil?
      session[:login_redirect] = request.fullpath
      redirect_to login_path
    end
  end
end
