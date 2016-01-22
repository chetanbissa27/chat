class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.where("id != ?",current_user.id).order("created_at DESC")
    @conversations = Conversation.involving(current_user).order("created_at DESC")
  end

  def profile
  	
  end

end
