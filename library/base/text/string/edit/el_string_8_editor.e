note
	description: "[
		Edit strings of type ${STRING_8} by applying an editing procedure to all
		occurrences of substrings that begin and end with a pair of delimiters.

		See `{${EL_STRING_EDITOR}}.delete_interior' for an example of an editing procedure
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-28 8:58:13 GMT (Thursday 28th March 2024)"
	revision: "8"

class
	EL_STRING_8_EDITOR

inherit
	EL_STRING_EDITOR [STRING_8]
		redefine
			new_string
		end

create
	make, make_empty

feature {NONE} -- Implementation

	area_count: INTEGER
		do
			Result := target.area.count
		end

	modify_target (str: STRING_8)
		do
			target.share (str)
		end

	new_string (general: READABLE_STRING_GENERAL): STRING
		do
			Result := general.to_string_8
		end

	trim
		-- trim target
		do
			target.trim
		end

	wipe_out (str: STRING_8)
		do
			str.wipe_out
		end
end