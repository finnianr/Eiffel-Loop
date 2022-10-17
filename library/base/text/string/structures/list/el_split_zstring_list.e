note
	description: "[
		A virtual split-list of [$source ZSTRING] represented as an array of [$INTEGER_64]
		substring intervals
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 12:37:05 GMT (Monday 17th October 2022)"
	revision: "10"

class
	EL_SPLIT_ZSTRING_LIST

inherit
	EL_SPLIT_STRING_LIST [ZSTRING]
		rename
			append_code as append_z_code,
			separator_code as separator_z_code
		redefine
			append_z_code, is_white_space, proper_cased, separator_z_code
		end

	EL_SHARED_ZSTRING_CODEC

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string, make_from_sub_list

feature {NONE} -- Implementation

	append_z_code (str: ZSTRING; z_code: NATURAL)
		do
			str.append_z_code (z_code)
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

end