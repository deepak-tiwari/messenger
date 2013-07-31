module MessagesHelper

	

	def recvmsg(user)
		Message.find(:all,
			         :conditions =>["to_user_id = ?",user.id],
			         :order   =>"created_at DESC")
	end

	def conversation(user1,user2)
	    Message.find(:all,
	    	         :conditions =>["(to_user_id = ? and from_user_id=?) 
	    	         	                   or 
	    	         	            (to_user_id = ? and from_user_id=?)",user1.id,user2.id,user2.id,user1.id] ,
			         :order   =>"created_at DESC")
	end

end
