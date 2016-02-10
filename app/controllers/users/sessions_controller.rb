class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  after_filter :publish_message, only: :create
  before_filter :publish_message, only: :destroy
  include PrivatePub::ViewHelpers

  protected

  def publish_message
    if current_user && params[:action] == "create"
      PrivatePub.publish_to "/user-online",message:{:id => current_user.id}
      # PrivatePub.publish_to "/chat",message:"var selector = #{current_user.id} ; $('li.user-list#pro-'+ selector + ' a>i.status').removeClass('fa-circle-o').addClass('fa-check-circle');"
    else
      PrivatePub.publish_to "/user-offline",message:{:id => current_user.id}
      # PrivatePub.publish_to "/chat",message:"var selector = #{current_user.id}; $('li.user-list#pro-'+ selector + ' a>i.status').removeClass('fa-check-circle').addClass('fa-circle-o');"
    end
  end
end
