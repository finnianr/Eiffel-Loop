note
	description: "Convenience routines for [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-28 13:40:29 GMT (Wednesday 28th February 2018)"
	revision: "4"

class
	EL_ZSTRING_ROUTINES

inherit
	EL_HEXADECIMAL_ROUTINES [ZSTRING]
		export
			{NONE} all
		end

	EL_SHARED_ONCE_STRINGS

	EL_STRING_CONSTANTS

feature {EL_MODULE_ZSTRING} -- Conversion

	as_zstring (str: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (str)
		end

end
