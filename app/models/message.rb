class Message < ActiveRecord::Base

	belongs_to :sender, class_name: "User"  ,foreign_key: "from_user_id"
    belongs_to :receiver,   class_name: "User" ,foreign_key: "to_user_id"
    default_scope -> { order('created_at DESC') }
    validates  :from_user_id, presence: true
    validates  :to_user_id,   presence: true
    validates  :content,      presence: true

end
