class Admin::AdminController < ActionController::Base
  include PublicActivity::StoreController

  before_filter :authenticate_user!
  protect_from_forgery with: :exception
  enable_authorization
  layout "application"

  rescue_from CanCan::Unauthorized do |exception|
    redirect_to new_user_session_url, :alert => request.path == "/admin" ? nil : exception.message
  end

  def current_user_unico_admin
    return AdminUser.master if current_user.is_a? AdminUser
    current_user
  end

  protected
end