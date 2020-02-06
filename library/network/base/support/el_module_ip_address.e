note
	description: "Shared access to routines of class [$source EL_IP_ADDRESS_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:20:36 GMT (Thursday 6th February 2020)"
	revision: "3"

deferred class
	EL_MODULE_IP_ADDRESS

inherit
	EL_MODULE

feature {NONE} -- Constants

	IP_address: EL_IP_ADDRESS_ROUTINES
		once
			create Result.make
		end

end
