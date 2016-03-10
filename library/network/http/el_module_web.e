note
	description: "Summary description for {EL_MODULE_WEB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_WEB

feature -- Access

	Web: EL_HTTP_CONNECTION
		once
			create Result.make
		end

end
