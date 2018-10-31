note
	description: "Shared instance of [$source EL_TUPLE_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-29 12:32:36 GMT (Monday 29th October 2018)"
	revision: "1"

class
	EL_MODULE_TUPLE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Tuple: EL_TUPLE_ROUTINES
		once
			create Result
		end
end
