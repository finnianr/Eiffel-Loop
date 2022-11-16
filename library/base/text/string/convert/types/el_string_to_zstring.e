note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_STRING_TO_ZSTRING

inherit
	EL_TO_STRING_GENERAL_TYPE [ZSTRING]

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.as_zstring (str)
		end

end