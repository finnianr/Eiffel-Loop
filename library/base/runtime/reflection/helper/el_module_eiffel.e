note
	description: "Shared access to routines of class [$source EL_INTERNAL] and ISE base class [$source INTERNAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-21 15:41:23 GMT (Friday 21st May 2021)"
	revision: "11"

deferred class
	EL_MODULE_EIFFEL

inherit
	EL_MODULE

feature {NONE} -- Constants

	Eiffel: EL_INTERNAL
			--
		once
			create Result
		end

end