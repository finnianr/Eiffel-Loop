note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 9:04:06 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_STRING_8

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [STRING_8]

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

end