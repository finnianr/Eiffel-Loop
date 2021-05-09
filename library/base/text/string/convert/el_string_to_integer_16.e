note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source INTEGER_16]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 8:40:20 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_INTEGER_16

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [INTEGER_16]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `INTEGER_16'
		do
			Result := str.is_integer_16
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): INTEGER_16
		do
			Result := str.to_integer_16
		end

end