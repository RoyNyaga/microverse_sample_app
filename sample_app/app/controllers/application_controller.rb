class ApplicationController < ActionController::Base
	def hello
		render html: "Good bye"
	end 
end
