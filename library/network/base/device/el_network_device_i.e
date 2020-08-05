note
	description: "Network device i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-05 19:28:20 GMT (Wednesday 5th August 2020)"
	revision: "1"

deferred class
	EL_NETWORK_DEVICE_I

inherit
	EL_SHARED_NETWORK_DEVICE_TYPE

	EL_MODULE_TUPLE

feature -- Access

	address: ARRAY [NATURAL_8]
		deferred
		end

	description: ZSTRING
		deferred
		end

	name: ZSTRING
		deferred
		end

	type_enum_id: NATURAL_8
		deferred
		end

feature -- Conversion

	to_adapter: EL_IP_ADAPTER
		do
			create Result.make (type_enum_id, name, description, address)
		end

feature {NONE} -- Constants

	Protocol: TUPLE [bluetooth, ethernet, usb, wireless: STRING]
		once
			create Result
			Tuple.fill (Result, "bluetooth, ethernet, usb, wireless")
		end

end
