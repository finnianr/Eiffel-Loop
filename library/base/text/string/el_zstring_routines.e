note
	description: "Convenience routines for ZSTRING"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-25 11:16:22 GMT (Thursday 25th May 2017)"
	revision: "2"

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
