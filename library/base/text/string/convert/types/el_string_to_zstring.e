note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 11:12:31 GMT (Wednesday 5th October 2022)"
	revision: "3"

class
	EL_STRING_TO_ZSTRING

inherit
	EL_READABLE_STRING_GENERAL_TO_STRING_TYPE [ZSTRING]

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.as_zstring (str)
		end

end