note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 17:52:42 GMT (Friday 11th April 2025)"
	revision: "9"

class
	EL_STRING_TO_STRING_8

inherit
	EL_TO_STRING_GENERAL_TYPE [STRING_8]
		redefine
			is_convertible
		end

create
	make

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `STRING_8'
		do
			Result := str.is_valid_as_string_8
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): STRING_8
		do
			Result := str.to_string_8
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_8
		do
			create Result.make (end_index - start_index + 1)
			super_readable_general (str).append_substring_to_string_8 (Result, start_index, end_index)
		end

end