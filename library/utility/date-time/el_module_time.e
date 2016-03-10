note
	description: "Summary description for {EL_MODULE_TIME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_TIME

inherit
	EL_MODULE

feature -- Access

	Time: EL_TIME_ROUTINES
			--
		once
			create Result.make
		end

end
