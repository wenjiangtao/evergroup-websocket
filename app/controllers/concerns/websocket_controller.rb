class WebsocketController < WebsocketRails::BaseController
	def signIn
		log("signIn", message.to_s)

		user = User.where("name" => message[:name]).first
		if (user.pwd == message[:pwd])
			currentUserId = user.getId
			connection_store[:currentUserId] = currentUserId
		end
		UserConnection.Create(currentUserId, connection.id)
		connection.send_message("onSignIn", {"channelId": user.getId})
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
		return User.find(connection_store[:currentUserId])
	end

	def connectionManager
		return connection.dispatcher.connection_manager
	end

	def connections
		return connection.dispatcher.connection_manager.connections
	end

	def clientConnected
		log("clientConnected", message.to_s)
	end

	def clientDisconnected
		log("clientConnected", message.to_s)
		UserConnection.Delete(connection.id)
	end

	def clientSubscribed
	end

	def clientSubscribedToPrivate
	end

	def log(op = nil, content = nil)
		op = op ? (" " + op.to_s) : " "
		content = content ? content.to_s : self.to_s
		puts "=====Log=====" + " " + self.class.to_s + op + ": " + content
	end
end