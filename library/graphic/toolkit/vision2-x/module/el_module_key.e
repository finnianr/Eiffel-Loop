note
	description: "Summary description for {EL_MODULE_KEY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_KEY

feature -- Access

	Key: EV_KEY_CONSTANTS
		once
			create Result
		end

end
