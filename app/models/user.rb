class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :f_name, :l_name ,:email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  validates_presence_of :f_name, :message => "First name can't be blank"
  validates_presence_of :l_name, :message => "Last name can't be blank"

  devise :omniauthable, :omniauth_providers => [:facebook]
  has_one :api_key

  def name
    self.f_name.to_s + " " + self.l_name.to_s
  end

  def self.load_fb_data(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.to_s
      user.password = Devise.friendly_token[0,20] #avoid password validation while login with facebook
      user.f_name = auth.info.first_name   # assuming the user model has a name
      user.l_name = auth.info.last_name
      user.image_url = auth.info.image # assuming the user model has an image
      user.is_activate = true
    end
    user.save!
    user
  end

  #this function must return ActiveRecord::Relation
  def conversations
    Conversation.where("sender_id = ? or recipient_id = ?",self.id,self.id)
  end

  def notifications
    conversations.includes(:messages).where("messages.is_read = false and user_id != ?",self.id)
  end

  def get_users
    User.where("users.id != #{self.id}").joins("left join conversations on (conversations.sender_id = users.id and conversations.recipient_id = #{self.id}) or
          (conversations.sender_id = #{self.id} and conversations.recipient_id = users.id) left join messages on conversations.id = messages.conversation_id
        and messages.user_id = users.id and messages.is_read = false").group("conversations.id").group("messages.user_id").select("users.*,count(messages.is_read) unread_count")
  end

end
