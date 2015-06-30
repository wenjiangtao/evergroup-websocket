class UserConnection < ModelBase
	include Mongoid::Document
	include Mongoid::Timestamps
	belongs_to :user_channel
	field :connection_id, type: String

	def self.Create(userChannelId, connectionId)
		userConnection = UserConnection.new
		userConnection.user_channel = UserChannel.find(userChannelId)
		userConnection.connection_id = connectionId
		userConnection.save
		userConnection.log("Create")
		return userConnection
	end

	def self.Delete(connectionId)
		userConnection = UserConnection.where(:connection_id => connectionId).first
		userConnection.log("Delete")
		userConnection.destroy
	end
end