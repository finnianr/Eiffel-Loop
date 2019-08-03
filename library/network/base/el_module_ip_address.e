note
	description: "Module ip address"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-03 16:29:34 GMT (Saturday 3rd August 2019)"
	revision: "1"

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
