class UserChannel < ModelBase
	include Mongoid::Document
	include Mongoid::Timestamps
	belongs_to :user
	has_many :user_connections, dependent: :destroy

	def self.Create(userId)
		userChannel = UserChannel.new
		userChannel.user = User.find(userId)
		userChannel.save
		userChannel.log("Create")
		return userChannel
	end

	def self.GetUserChannelByUser(userId)
		userChannel = User.find(userId).user_channel
		return userChannel ? userChannel : UserChannel.Create(userId)

	def self.Delete(userId)
		userChannel = UserConnection.where(:user => User.find(userId)).first
		userChannel.log("Delete")
		userChannel.destroy
	end
end