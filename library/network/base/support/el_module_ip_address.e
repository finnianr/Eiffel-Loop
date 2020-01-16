note
	description: "Module ip address"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-16 12:08:09 GMT (Thursday 16th January 2020)"
	revision: "2"

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
