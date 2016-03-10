note
	description: "Summary description for {EL_MODULE_STRING_32}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_STRING_32

inherit
	EL_MODULE

feature -- Access

	String_32: EL_STRING_X_ROUTINES [STRING_32]
			--
		once
			create Result
		end
end
