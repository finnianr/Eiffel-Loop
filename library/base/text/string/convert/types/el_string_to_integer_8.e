note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source INTEGER_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 9:25:58 GMT (Wednesday 5th October 2022)"
	revision: "2"

class
	EL_STRING_TO_INTEGER_8

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [INTEGER_8]
		redefine
			is_convertible
		end

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `INTEGER_8'
		do
			Result := str.is_integer_8
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): INTEGER_8
		do
			Result := str.to_integer_8
		end

end