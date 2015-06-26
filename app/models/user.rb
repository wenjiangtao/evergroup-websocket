class User < ModelBase
	include Mongoid::Document
	include Mongoid::Timestamps
	has_many :chat_rooms, dependent: :destroy
	has_many :chat_users, dependent: :destroy
	has_many :user_connections, dependent: :destroy
	has_many :sign_tokens, dependent: :destroy
	field :name, type: String
	field :pwd, type: String

	def self.GetCurrentUser(token = nil)
		signToken = token ? token : session[:signToken]
		SignToken.find(signToken).user
	end
end