note
	description: "Shared access to routines of class [$source EL_TUPLE_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:25:58 GMT (Thursday 6th February 2020)"
	revision: "3"

deferred class
	EL_MODULE_TUPLE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Tuple: EL_TUPLE_ROUTINES
		once
			create Result
		end
end
