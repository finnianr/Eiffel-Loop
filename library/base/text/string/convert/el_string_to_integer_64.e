note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source INTEGER_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 8:40:29 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_INTEGER_64

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [INTEGER_64]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `INTEGER_64'
		do
			Result := str.is_integer_64
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): INTEGER_64
		do
			Result := str.to_integer_64
		end

end