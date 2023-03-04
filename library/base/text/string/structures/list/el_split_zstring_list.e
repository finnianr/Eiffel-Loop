note
	description: "[
		A virtual split-list of [$source ZSTRING] represented as an array of [$INTEGER_64]
		substring intervals
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-04 9:54:15 GMT (Saturday 4th March 2023)"
	revision: "15"

class
	EL_SPLIT_ZSTRING_LIST

inherit
	EL_SPLIT_STRING_LIST [ZSTRING]
		rename
			append_code as append_z_code,
			separator_code as separator_z_code
		redefine
			append_z_code, is_white_space, is_valid_character, proper_cased, separator_z_code,
			string_strict_cmp
		end

	EL_SHARED_ZSTRING_CODEC

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature {NONE} -- Implementation

	append_z_code (str: ZSTRING; z_code: NATURAL)
		do
			str.append_z_code (z_code)
		end

	is_valid_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := True
		end

	is_white_space (a_target: ZSTRING; i: INTEGER): BOOLEAN
		do
			Result := a_target.is_space_item (i)
		end

	proper_cased (word: ZSTRING): ZSTRING
		do
			Result := word.as_proper_case
		end

	separator_z_code (a_separator: CHARACTER_32): NATURAL
		do
			Result := codec.as_z_code (a_separator)
		end

	string_strict_cmp (left_index, right_index, n: INTEGER): INTEGER
		do
--			order `right_index', `left_index' is correct
			Result := target.order_comparison (target, right_index, left_index, n)
		end

end