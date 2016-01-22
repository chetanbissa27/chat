class Api::ApiController < ActionController::Base
  skip_before_filter :http_auth
	before_filter :authenticate

	def authenticate
    auth_header = request.headers['Authorization'].to_s
    #Rails.logger.ap  "auth header #{ auth_header } "
    access_token = auth_header[/token="(.*?)"/,1]

	  #access_token = request.headers['access_token'].to_s
	  #api_key = auth_header[/token="(.*?)"/,1]

	  if access_token.nil?
      render :json => {:success => false, :error_code => :key_not_sent, :error_message => "Key Not sent"}, :status => 401
      return
    else
    	access_token = ApiKey.where("access_token =? and expires_at >?", access_token, Time.now ).last
      if access_token.nil?
        render :json => {:success => false, :error_code => :key_expired, :error_message => "Access token has Expired"}, :status => 401
        return
      else
        access_token.expires_at = Time.now + 60.minutes
        access_token.save
        @current_user = access_token.user
      end
    end
	end

  helper_method :current_user

  private
  def current_user
    @current_user || User.first
  end

end
