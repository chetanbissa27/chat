class Api::V1::SessionsController < Devise::SessionsController
	skip_filter :authenticate
	respond_to :json
	
	def create
    resource = User.find_for_database_authentication(:email => params[:email])
    return invalid_login_attempt unless resource
    if resource.valid_password?(params[:password])
      @api_key = ApiKey.find_or_create_token_for(resource)
      resource.update_attributes(params[:push_notification_details]) unless params[:push_notification_details].blank?
      Rails.logger.ap @api_key
      render "api/v1/api_keys/show.json.jbuilder"
      return
    end
    invalid_login_attempt
  end

end
