note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source REAL_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 8:41:01 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_REAL_32

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [REAL_32]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `REAL_32'
		do
			Result := str.is_real_32
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): REAL_32
		do
			Result := str.to_real_32
		end

end