note
	description: "Shared access to routines of class [$source EL_TUPLE_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 10:36:53 GMT (Monday 3rd May 2021)"
	revision: "4"

deferred class
	EL_MODULE_TUPLE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Tuple: EL_TUPLE_ROUTINES
		once
			create Result.make
		end
end