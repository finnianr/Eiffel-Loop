note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source INTEGER_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 9:25:52 GMT (Wednesday 5th October 2022)"
	revision: "2"

class
	EL_STRING_TO_INTEGER_64

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [INTEGER_64]
		redefine
			is_convertible
		end

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