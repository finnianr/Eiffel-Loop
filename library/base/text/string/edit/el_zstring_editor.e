note
	description: "[
		Edit strings of type [$source EL_ZSTRING] by applying an editing procedure to all
		occurrences of substrings that begin and end with a pair of delimiters.

		See `{[$source EL_STRING_EDITOR]}.delete_interior' for an example of an editing procedure
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_ZSTRING_EDITOR

inherit
	EL_STRING_EDITOR [ZSTRING]

create
	make

feature {NONE} -- Implementation

	set_target (str: ZSTRING)
		do
			target.share (str)
		end

	wipe_out (str: ZSTRING)
		do
			str.wipe_out
		end

end
