class Api::V1::SearchController < Api::ApiController

	skip_filter :authenticate, :only => [:search]
	respond_to :json

	# API to store and fetch search results for user
	def search
		begin
		  # Need a variable to avoid duplicate record insertion while applying filters	
	      if params[:is_new].to_s.downcase == "true"
	        history = UserSearchHistory.new(params[:location])
	        history.save!
	        mongo_user_search = MongoUserSearch.add_search_records(current_user,params[:location]) unless current_user.blank?
	      end
	      @records = MongoUserSearch.records_in_miles(current_user,params[:location][:latitude],params[:location][:longitude])
	      render :json => {:success => true, :message => "search successful" ,:results => @records}, :status => 200
	    rescue Exception => e
	    	p e
	      render :json => {:success => false, :message => "Error", :results => @records}, :status => 200
	    end
	end

end
