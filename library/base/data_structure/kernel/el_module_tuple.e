note
	description: "Shared instance of [$source EL_TUPLE_ROUTINES]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_TUPLE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Tuple: EL_TUPLE_ROUTINES
		once
			create Result
		end
end
