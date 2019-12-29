note
	description: "Shared network device type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-29 13:40:03 GMT (Sunday 29th December 2019)"
	revision: "1"

deferred class
	EL_SHARED_NETWORK_DEVICE_TYPE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Network_device_type: EL_NETWORK_DEVICE_TYPE_ENUM
		once
			create Result.make
		end
end
