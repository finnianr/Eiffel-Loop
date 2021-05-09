note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 8:54:00 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_ZSTRING

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [ZSTRING]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `ZSTRING'
		do
			Result := str.is_string_32
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.as_zstring (str)
		end

end