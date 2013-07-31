class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy

  #relationship associations
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships


  #messages associations
  has_many :messages ,foreign_key: "from_user_id", dependent: :destroy
  has_many :senders ,through: :messages  , source: :from_user_id
  has_many :inverse_messages, foreign_key: "to_user_id",
                                   class_name:  "Messages",
                                   dependent:   :destroy
  has_many :receivers ,through: :messages  , source: :to_user_id


  before_save { self.email = email.downcase }
  before_create :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def my_messages
      Message.where("to_user_id = ?",id)
  end

  def sent_messages
      Message.where("from_user_id= ?",id)
  end

  def all_messages
      Message.where("from_user_id= ? or to_user_id=?",id,id)
  end 

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end