note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source INTEGER_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 8:40:24 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_INTEGER_32

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [INTEGER_32]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `INTEGER_32'
		do
			Result := str.is_integer_32
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): INTEGER_32
		do
			Result := str.to_integer_32
		end

end