class HomeController < ApplicationController
  
  def index
  	@records = current_user.blank? ? [] : User.where("id != ?",current_user.id)
  end

  def search_result
  	
  end

end
