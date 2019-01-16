note
	description: "[
		Edit strings of type `STRING_8' by applying an editing procedure to all
		occurrences of substrings that begin and end with a pair of delimiters.

		See `{[$source EL_STRING_EDITOR]}.delete_interior' for an example of an editing procedure
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-09 12:37:49 GMT (Wednesday 9th January 2019)"
	revision: "2"

class
	EL_STRING_8_EDITOR

inherit
	EL_STRING_EDITOR [STRING_8]
		redefine
			new_string
		end

create
	make

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): STRING
		do
			Result := general.to_string_8
		end

	set_target (str: STRING_8)
		do
			target.share (str)
		end

	wipe_out (str: STRING_8)
		do
			str.wipe_out
		end
end
