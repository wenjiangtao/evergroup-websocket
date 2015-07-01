WebsocketRails::EventMap.describe do

	namespace :websocket_rails do 
		subscribe :subscribe, to: WebsocketController, with_method: :clientSubscribed
		subscribe :subscribe_private, to: WebsocketController, with_method: :clientSubscribedToPrivate
	end
	# subscribe :subscribe, to: WebsocketController, with_method: :clientSubscribed
	

	subscribe :client_connected, to: ChatController, with_method: :clientConnected
	subscribe :client_disconnected, to: ChatController, with_method: :clientDisconnected
	subscribe :signIn, to: ChatController, with_method: :signIn
	subscribe :createUser, to: ChatController, with_method: :createUser
	subscribe :chatWith, to: ChatController, with_method: :chatWith
	subscribe :sendMsg, to: ChatController, with_method: :sendMsg
end
