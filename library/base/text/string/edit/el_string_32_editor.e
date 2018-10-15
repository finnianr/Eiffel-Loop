note
	description: "[
		Edit strings of type `STRING_32' by applying an editing procedure to all
		occurrences of substrings that begin and end with a pair of delimiters.

		See `{[$source EL_STRING_EDITOR]}.delete_interior' for an example of an editing procedure
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_STRING_32_EDITOR

inherit
	EL_STRING_EDITOR [STRING_32]

create
	make

feature {NONE} -- Implementation

	set_target (str: STRING_32)
		do
			target.share (str)
		end

	wipe_out (str: STRING_32)
		do
			str.wipe_out
		end
end
