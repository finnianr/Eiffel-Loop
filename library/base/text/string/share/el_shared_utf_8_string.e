note
	description: "Shared instance of [$source EL_UTF_8_STRING]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_SHARED_UTF_8_STRING

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	UTF_8_string: EL_UTF_8_STRING
		once
			create Result.make (0)
		end

end
