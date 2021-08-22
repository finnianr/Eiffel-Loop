note
	description: "[
		List of [$source EL_ZSTRING] split parts delimited by `delimiter'
		
		This is a more efficient way to process split strings as it doesn't create a new string
		instance for each split part.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-22 15:00:10 GMT (Sunday 22nd August 2021)"
	revision: "8"

class
	EL_SPLIT_ZSTRING_LIST

inherit
	EL_SPLIT_STRING_LIST [ZSTRING]
		rename
			append_code as append_z_code,
			separator_code as separator_z_code
		redefine
			append_z_code, proper_cased, separator_z_code
		end

	EL_SHARED_ZSTRING_CODEC

create
	make, make_empty, make_from_sub_list, make_with_character

feature {NONE} -- Implementation

	append_z_code (str: ZSTRING; z_code: NATURAL)
		do
			str.append_z_code (z_code)
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