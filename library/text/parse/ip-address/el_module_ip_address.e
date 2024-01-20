note
	description: "Shared access to routines of class ${EL_IP_ADDRESS_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "6"

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