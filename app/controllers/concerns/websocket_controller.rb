class WebsocketController < WebsocketRails::BaseController
	def signIn
		log("signIn", message.to_s)

		user = User.where("name" => message[:name]).first
		if user.pwd == message[:pwd]
			log("SignSuccess")
			userId = user.getId
			connection_store[:userId] = userId
			userChannel = UserChannel.GetUserChannelByUser(userId)
			connection_store[:userChannelId] = userChannel.getId
			log("userChannelId", connection_store[:userChannelId])
			UserConnection.Create(userChannel.getId, connection.id)
			connection.send_message("onSignIn", {"channel": userChannel.getId})
			# User.each do |eachUser|
			# 	eachUser.user_channel.user_connections.each do |eachUserConnection|
			# 		WebsocketRails.users[eachUserConnection.connection_id].send_message("userSignIn", {"user": user.to_json})
			# 	end
			# end
			# WebsocketRails.users.each do |eachUser|
			# 	log("user", eachUser)
			# end
			log("connections", connection.dispatcher.connection_manager.connections)
			log("users", WebsocketRails.users[connection.id])
			log("user", connection.user)
		end
		
		# currentUserId = User.GetCurrentUser(message[:signToken]).getId
		# connection_store[:currentUserId] = currentUserId
		# userConnection = UserConnection.NewUserConnection(currentUserId, connection.id)
	end

	def createUser
		log("createUser", message.to_s)
		user = User.new
		user.name = message[:name]
		user.pwd = message[:pwd]
		user.save
	end

	def currentUser
		return User.find(connection_store[:userId])
	end

	# def currentUserChannelId
	# 	return connection_store[:userChannelId]
	# end

	# def connectionManager
	# 	return connection.dispatcher.connection_manager
	# end

	# def connections
	# 	return connection.dispatcher.connection_manager.connections
	# end

	def clientConnected
		log("clientConnected", message)
	end

	def clientDisconnected
		log("clientDisconnected", message)
		UserConnection.Delete(connection.id)
	end

	def clientSubscribed
		log("clientSubscribed", message)
		# log("messageChannel", message[:channel])
		# log("connectionStoreChannel", connection_store[:userChannelId])
		# message[:channel] == connection_store[:userChannelId] ? acceptChannel : denyChannel
	end

	# def acceptChannel
	# 	log("acceptChannel", message)
	# 	accept_channel(message)
	# end

	# def denyChannel
	# 	log("denyChannel", message)
	# 	deny_channel(message)
	# end

	def clientSubscribedToPrivate
		log("clientSubscribedToPrivate", message)
		message[:channel] == connection_store[:userChannelId] ? accept_channel : deny_channel
	end

	def log(op = nil, content = nil)
		puts ""
		op = op ? (" " + op.to_s) : " "
		content = content ? content.to_s : self.to_s
		puts "=====Log=====" + " " + self.class.to_s + op + ": " + content
		puts ""
	end
end