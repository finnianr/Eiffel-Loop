note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-03 14:23:22 GMT (Thursday 3rd April 2025)"
	revision: "9"

class
	EL_STRING_TO_STRING_32

inherit
	EL_TO_STRING_GENERAL_TYPE [STRING_32]
		redefine
			is_latin_1
		end

create
	make

feature -- Status query

	is_latin_1: BOOLEAN = False
		-- `True' if type can be always be represented by Latin-1 encoded string

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): STRING_32
		do
			Result := str.to_string_32
		end

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_32
		do
			create Result.make (end_index - start_index + 1)
			super_readable_general (str).append_substring_to_string_32 (Result, start_index, end_index)
		end

end