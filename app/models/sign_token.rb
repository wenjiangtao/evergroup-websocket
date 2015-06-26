class SignToken < ModelBase
	include Mongoid::Document
	include Mongoid::Timestamps
	belongs_to :user

	def getSignToken
		return {"signToken": getId}
	end
end