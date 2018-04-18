note
	description: "Convenience routines for [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-02 13:14:09 GMT (Monday 2nd April 2018)"
	revision: "5"

class
	EL_ZSTRING_ROUTINES

inherit
	EL_SHARED_ONCE_STRINGS

	EL_STRING_CONSTANTS

feature {EL_MODULE_ZSTRING} -- Conversion

	as_zstring (str: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (str)
		end

end
