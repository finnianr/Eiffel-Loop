note
	description: "[
		Edit strings of type [$source EL_ZSTRING] by applying an editing procedure to all
		occurrences of substrings that begin and end with a pair of delimiters.

		See `{[$source EL_STRING_EDITOR]}.delete_interior' for an example of an editing procedure
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-28 18:00:36 GMT (Sunday 28th February 2021)"
	revision: "2"

class
	EL_ZSTRING_EDITOR

inherit
	EL_STRING_EDITOR [ZSTRING]

create
	make, make_empty

feature {NONE} -- Implementation

	modify_target (str: ZSTRING)
		do
			target.share (str)
		end

	wipe_out (str: ZSTRING)
		do
			str.wipe_out
		end

end