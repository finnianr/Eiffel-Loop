note
	description: "Shared network device type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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