note
	description: "Shared access to routines of class [$source EL_IP_ADDRESS_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-29 10:49:05 GMT (Monday 29th November 2021)"
	revision: "4"

deferred class
	EL_MODULE_IP_ADDRESS

inherit
	EL_MODULE

feature {NONE} -- Constants

	IP_address: EL_IP_ADDRESS_ROUTINES
		once
			create Result
		end

end