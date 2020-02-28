class Admin::HomeController < Admin::AdminController
  before_filter :authenticate_user!

  def index
  end
end