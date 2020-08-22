note
	description: "Shared access to instance of [$source EL_ORIENTATION_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-21 10:07:43 GMT (Friday 21st August 2020)"
	revision: "1"

deferred class
	EL_MODULE_ORIENTATION

inherit
	EL_MODULE

feature -- Constants

	Orientation: EL_ORIENTATION_ROUTINES
		once
			create Result
		end
end
