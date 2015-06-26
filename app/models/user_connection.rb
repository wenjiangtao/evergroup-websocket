class UserConnection < ModelBase
	include Mongoid::Document
	include Mongoid::Timestamps
	belongs_to :user
	field :connection_id, type: String

	def self.Create(userId, connectionId)
		userConnection = UserConnection.new
		userConnection.user = User.find(userId)
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