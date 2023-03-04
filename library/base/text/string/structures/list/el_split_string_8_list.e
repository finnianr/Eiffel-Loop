note
	description: "[
		A virtual split-list of [$source STRING_8] represented as an array of [$INTEGER_64]
		substring intervals
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-04 9:52:48 GMT (Saturday 4th March 2023)"
	revision: "15"

class
	EL_SPLIT_STRING_8_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_8]
		redefine
			is_white_space, is_valid_character, same_i_th_character, target
		end

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature {NONE} -- Implementation

	is_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target [i].is_space
		end

	is_valid_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := uc.is_character_8
		end

	same_i_th_character (a_target: like target; i: INTEGER; uc: CHARACTER_32; c: CHARACTER): BOOLEAN
		do
			Result := a_target [i] = c
		end

feature {NONE} -- Internal attributes

	target: STRING_8
end