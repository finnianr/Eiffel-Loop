note
	description: "Shared access to routines of class [$source EL_ZSTRING_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:28:11 GMT (Thursday 6th February 2020)"
	revision: "8"

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
