class ChatRoom < ModelBase
	include Mongoid::Document
	include Mongoid::Timestamps
	has_many :chat_users, dependent: :destroy
	has_many :chat_msgs, dependent: :destroy

	def self.Create(userIds)
		chatRoom = ChatRoom.new
		chatRoom.save
		userIds.each do |eachUserId|
			chatRoom.addUser(eachUserId)
		end
		chatRoom.log("Create")
		return chatRoom
	end

	def addUser(userId)
		ChatUser.Create(userId, getId)
	end


end
