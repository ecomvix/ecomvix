class ApplicationController < ActionController::Base

    protect_from_forgery with: :exception


   #include CurrentCart
  # before_action :set_product, only: [:show, :edit, :update, :destroy]
  # before_action :set_cart, only: [:index, :shop, :about, :search_results, :new]

  # skip_before_action :authenticate_user!, only: [:index, :shop, :about, :search_results, :new]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 

  before_action :configure_permitted_parameters, if: :devise_controller?


   helper_method :current_user_admin?
  #before_action :authenticate_user!


    def current_user_admin?
    user_signed_in? && current_user.admin
   end

  protected

  def configure_permitted_parameters
    #devise_parameter_sanitizer.for(:sign_up) << :name
    #devise_parameter_sanitizer.for(:account_update) << :name
    #devise_parameter_sanitizer.permit(:sign_up) << :name
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit({ roles: [] }, :name, :email, :password, :password_confirmation, :username) }
  end


  def admin_required
    redirect_back(fallback_location: root_path, notice: "You can not view this page.") unless current_user_admin?
  end
 



  def require_admin
    unless current_user.admin?
      flash[:danger] = "You have to be an admin to do that!"
      redirect_to root_path
    end
  end


end
