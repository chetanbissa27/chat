class HomeController < ApplicationController
  
  def index
  	@records = current_user.blank? ? [] : current_user.get_users
  end

  def search_result
  	
  end

end
