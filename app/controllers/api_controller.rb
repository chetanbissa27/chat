class ApiController < ApplicationController

  def store_search_history
    begin
      params[:data][:user_id] = current_user.id
      history = UserSearchHistory.new(params[:data])
      history.save!

      user_data = {:f_name => current_user.f_name, :l_name => current_user.l_name, :birthday => current_user.birthday,
                   :gender => current_user.gender, :phone => current_user.phone, :occupation => current_user.occupation,
                   :have_room => current_user.have_room, :is_activate => current_user.is_activate, :hobbies => current_user.hobbies,
                   :uid => current_user.uid, :email => current_user.email, :image_url => current_user.image_url, 
                   :loc => [params[:data][:longitude].to_f, params[:data][:latitude].to_f]}

      # mongo_user_search = MongoUserSearch.add_search_records(params[:data].merge(user_data))

      # res = MongoUserSearch.get_search_result mongo_user_search.loc

      # p res.count

      # p res.to_a

      render :json => {:status => true,:message => "Added Successfully."}
    rescue Exception => e
      render :json => {:status => false,:error => e.message}
    end
  end

end