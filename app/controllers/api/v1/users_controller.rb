class Api::V1::UsersController <  Api::ApiController

	skip_filter :authenticate, :only => [:create]
  respond_to :json

  # API for user registration
  def create
    @user = User.where(:email => params[:user][:email]).first

    if !@user.nil?
    	render :json => {:success => false, :message => "User already registered"}, :status => 401
    else
    	begin
		    @user = User.new(params[:user])
        @user.password = Devise.friendly_token[0,20]
		    if @user.save
		      @api_key = ApiKey.find_or_create_token_for(@user)
		      render :json => {:success => true, :message => "Registration successful",:access_key => @api_key.access_token, :user => @user}, :status => 200
		    else
		     	render :json => {:success => false, :message => "Error while creating user"}, :status => :not_acceptable
		    end
		  rescue Exception => e
        p e
	     	p e.backtrace
	      render :json => {:success => false, :message => e.backtrace}, :status => :not_acceptable
	    end
	  end
  end


  # API to find Room mate details
  def get_room_mate
  	if !params[:room_mate_id].blank?
  		@user = User.find_by_id params[:room_mate_id]
  		if !@user.nil?
  			render :json => {:success => true, :message => "Room mate found", :user => @user}, :status => 200
  		else
  			render :json => {:success => false, :message => "Room mate not found"}, :status => :not_acceptable
  		end
		end  	
  end

  # API to update user profile
  def update_profile
  	@user = User.find_by_id(params[:id])
  	if @user.nil?
      render :json => {:message => "User not exists"}, :status => :not_acceptable
    else
    	begin
	      @user.update_attributes(params[:user])
	      @user.save!
	      render :json => {:success => true, :message => "User updated", :user =>@user}, :status => :ok
	     rescue Exception => e
	     	p e.backtrace
	      render :json => {:success => false, :message => e.backtrace}, :status => :not_acceptable
	    end
    end
  end

  # API to deactivate profile
  def deactivate_profile
  	@user = User.find_by_id(params[:id])
  	if @user.nil?
      render :json => {:success => false, :message => "User not exists"}, :status => :not_acceptable
    else
    	begin
	      @user.is_activate = false
	      @user.save!
	      render :json => {:success => true,:message => "User profile deactivated", :user =>@user}, :status => :ok
	     rescue Exception => e
	     	p e.backtrace
	      render :json => {:success => false, :message => e.backtrace}, :status => :not_acceptable
	    end
    end
  end

  # API for signout
  def destroy
    p current_user
    begin
      api_key = current_user.api_key
      if  !api_key.nil?
        api_key.expires_at = Time.now
        api_key.save
        render :json => {:success => true, :message => "Logged out successfully"}
      else
        render :json => {:success => false, :message => "Access token not found for user"}
      end
      # current_user.api_key.expires_at = Time.now
      # current_user.save!
    rescue Exception => e
      p e.backtrace
      render :json => {:success => false, :message => e.backtrace}, :status => :not_acceptable
    end
  end

end
