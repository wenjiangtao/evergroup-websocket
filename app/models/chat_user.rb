class ChatUser < ModelBase
	include Mongoid::Document
	include Mongoid::Timestamps
	belongs_to :chat_room
	belongs_to :user
	has_many :chat_msgs, dependent: :destroy
	field :nickname, type: String

	def self.Create(userId, chatRoomId, nickname = nil)
		chatUser = ChatUser.new
		chatUser.user = User.find(userId)
		chatUser.chat_room = ChatRoom.find(chatRoomId)
		chatUser.nickname = nickname ? nickname : chatUser.user.name
		chatUser.save
		chatUser.log("Create")
		return chatUser
	end

	def sendMsg(content)
		ChatMsg.Create(getId, chat_room.getId, content)
	end

	def getOtherChatUsers
		otherChatUsers = []
		chat_room.chat_users.each do |eachChatUser|
			if eachChatUser != self
				otherChatUsers.push(eachChatUser)
			end
		end
		return otherChatUsers
	end
end
