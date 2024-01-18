note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${IMMUTABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 13:02:25 GMT (Saturday 18th November 2023)"
	revision: "8"

class
	EL_STRING_TO_IMMUTABLE_STRING_8

inherit
	EL_TO_STRING_GENERAL_TYPE [IMMUTABLE_STRING_8]
		redefine
			is_convertible
		end

	EL_SHARED_IMMUTABLE_8_MANAGER

create
	make

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `STRING_8'
		do
			Result := str.is_valid_as_string_8
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): IMMUTABLE_STRING_8
		do
			Result := str.to_string_8
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): IMMUTABLE_STRING_8
		local
			str_8: STRING_8
		do
			create str_8.make (end_index - start_index + 1)
			shared_cursor (str).append_substring_to_string_8 (str_8, start_index, end_index)
			Result := Immutable_8.as_shared (str_8)
		end

end