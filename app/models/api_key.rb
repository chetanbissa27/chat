class ApiKey < ActiveRecord::Base
  attr_accessible :access_token, :expires_at, :user_id
  belongs_to :user
  before_create :generate_access_token
  
  def self.find_or_create_token_for user
    api_key = find_token_for(user) || self.create!({:user_id => user.id})
    api_key.expires_at = Time.now + 30.minutes
    api_key.save
    api_key
  end

  def self.find_token_for user
    self.where("user_id=? and expires_at<?", user.id,Time.now).first
  end

  def token_exists_for_user?
   return !User.where("user_id=? and expires_at<?", self.user_id,Time.now).empty?
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
  
end
