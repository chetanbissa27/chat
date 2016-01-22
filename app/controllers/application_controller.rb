class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :back_url
  # before_filter :authenticate_user!
  # before_filter :http_auth
  before_filter :user_notifications

  def http_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == "chat" && password == "chat123#"
    end
  end
  def back_url
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def user_notifications
    @user_notifications = []
    if current_user
      @user_notifications = current_user.notifications
    end
    @user_notifications
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
end
