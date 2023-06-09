note
	description: "[
		A list of substring index intervals conforming to [$source EL_SPLIT_INTERVALS]
		for a string of type [$source STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-09 7:35:50 GMT (Friday 9th June 2023)"
	revision: "20"

class
	EL_SPLIT_STRING_8_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_8]
		undefine
			fill_by_string, is_valid_character, is_white_space, same_i_th_character, shared_cursor
		redefine
			default_target, target
		end

	EL_STRING_8_OCCURRENCE_IMPLEMENTATION [STRING_8]

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature -- Element change

	append_string (str: STRING_8)
		do
			if target = default_target then
				target := str.twin
				extend (1, str.count)
			else
				target.append (str)
				extend (last_upper + 1, target.count)
			end
		end

	trim_string
		do
			target.trim
		end

feature {NONE} -- Implementation

	default_target: STRING_8
		do
			Result := Empty_string_8
		end

feature {NONE} -- Internal attributes

	target: STRING_8
end