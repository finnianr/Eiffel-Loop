note
	description: "Summary description for {EL_MODULE_STRING_8}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_STRING_8

inherit
	EL_MODULE

feature -- Access

	String_8: EL_STRING_X_ROUTINES [STRING_8]
			--
		once
			create Result
		end
end
