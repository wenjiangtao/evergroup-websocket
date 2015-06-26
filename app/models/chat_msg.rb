class ChatMsg < ModelBase
	include Mongoid::Document
	include Mongoid::Timestamps
	belongs_to :chat_room
	belongs_to :chat_user
	field :content, type: String

	def self.Create(chatUserId, chatRoomId, content)
		chatMsg = ChatMsg.new
		chatMsg.chat_user = ChatUser.find(chatUserId)
		chatMsg.chat_room = ChatRoom.find(chatRoomId)
		chatMsg.content = content
		chatMsg.save
		chatMsg.log("Create")
		return chatMsg
	end
end