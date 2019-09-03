note
	description: "Module zstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-03 13:17:57 GMT (Tuesday 3rd September 2019)"
	revision: "7"

deferred class
	EL_MODULE_ZSTRING

inherit
	EL_MODULE

feature {NONE} -- Constants

	ZString: EL_ZSTRING_ROUTINES
			--
		once
			create Result
		end
end
