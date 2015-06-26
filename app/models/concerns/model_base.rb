class ModelBase
	def self.Get(limit = nil)
		self.desc(:created_at).limit(limit)
	end

	def self.Create()
		modelBase = self.new
		modelBase.save
		modelBase.log("Create")
		return modelBases
	end

	def getId
		return JSON.parse(self.id.to_json)["$oid"]
	end

	def log(op = "", content = nil)
		content = content ? content : self.to_s
		puts "=====Log=====" + " " + self.class.to_s + " " + op + ": " + self.to_s
	end
end

