class ChatController < WebsocketController

	def initialize_session
	end

	def chatWith
		log("currentUser", currentUser)
		log("chatWith", message)
		if message[:userIds]
			chatTargets = message[:userIds]
			puts "=====chatTargets.count: " + chatTargets.count.to_s
			if chatTargets.count == 1
				chatRoom = getChatRoomIdOfSingleUser(chatTargets.first)
			end

			if chatRoom == nil
				userIds = []
				userIds.push(currentUser.getId)

				chatTargets.each do |eachChatTarget|
					userIds.push(eachChatTarget)
				end
				log("newChatRoomUserIds", userIds)
				chatRoom = ChatRoom.Create(userIds)
				brocastMessageToChatRoom(chatRoom.getId, "chatRoom.create", {"chatRoomId": chatRoom.getId, "userIds": userIds})
			end
		elsif message[:chatRoomId]
			chatRoom = ChatRoom.find(message[:chatRoomId])
			chatRoom.addUser(currentUser.getId)
			brocastMessageToChatRoom(chatRoom.getId, "chatRoom.addUser", {"chatRoomId": message[:chatRoomId], "userId": currentUser.getId})
		end
	end

	def sendMsg
		log("currentUser", currentUser)
		log("sendMsg", message)
		if message[:chatRoomId]
			chatRoom = ChatRoom.find(message[:chatRoomId])
		elsif message[:userId]
			chatRoom = getChatRoomIdOfSingleUser(message[:userId])
			puts "====chatRoom: " + chatRoom.to_json
			if chatRoom == nil
				chatTargets = []
				chatTargets.push(message[:userId])
				chatTargets.push(currentUser.getId)
				chatRoom = ChatRoom.Create(chatTargets)
				brocastMessageToChatRoom(chatRoom.getId, "chatRoom.create", {"chatRoomId": chatRoom.getId, "userIds": message[:userIds]})
			end
		end
		chatUser = currentUser.chat_users.where(:chat_room => chatRoom).first
		puts "=====chatUser: " + chatUser.to_json
		chatUser.sendMsg(message[:content])

		brocastMessageToChatRoom(chatRoom.getId, "chatUser.sendMsg", {"chatRoomId": chatRoom.getId,"userId": currentUser.getId, "content": message[:content]})
	end

	private

	def brocastMessageToChatRoom(chatRoomId, eventName, messageObject)
		chatRoom = ChatRoom.find(chatRoomId)
		chatRoom.chat_users.each do |eachChatUser|
			eachUserChannel = eachChatUser.user.user_channel
			if eachUserChannel.user_connections.count > 0
				log("eachUserChannel", eachUserChannel.to_json)
				log("eachUserChannelConnectionCount", eachUserChannel.user_connections.count)
				eachUserChannelId = eachUserChannel.getId
				WebsocketRails[eachUserChannelId].trigger(eventName, messageObject)
			end
		end
	end

	def getChatRoomIdOfSingleUser(userId)
		currentUser.chat_users.each do |eachChatUser|
			otherChatUsers = eachChatUser.getOtherChatUsers
			if otherChatUsers.count == 1 && otherChatUsers[0].user.getId == userId
				return eachChatUser.chat_room
			end
		end
		return nil
	end

end
