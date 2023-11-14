note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source IMMUTABLE_STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-14 17:23:12 GMT (Tuesday 14th November 2023)"
	revision: "6"

class
	EL_STRING_TO_IMMUTABLE_STRING_32

inherit
	EL_TO_STRING_GENERAL_TYPE [IMMUTABLE_STRING_32]
		redefine
			is_latin_1
		end

	EL_SHARED_IMMUTABLE_32_MANAGER

feature -- Status query

	is_latin_1: BOOLEAN = False
		-- `True' if type can be always be represented by Latin-1 encoded string

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): IMMUTABLE_STRING_32
		do
			Result := str.to_string_32
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): IMMUTABLE_STRING_32
		local
			str_32: STRING_32
		do
			create str_32.make (end_index - start_index + 1)
			shared_cursor (str).append_substring_to_string_32 (str_32, start_index, end_index)
			Result := Immutable_32.as_shared (str_32)
		end

end