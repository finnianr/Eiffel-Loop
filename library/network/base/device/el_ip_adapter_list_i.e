note
	description: "List of network device adapters that have an actual hardware address"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-05 19:47:43 GMT (Wednesday 5th August 2020)"
	revision: "8"

deferred class
	EL_IP_ADAPTER_LIST_I

inherit
	EL_ARRAYED_LIST [EL_IP_ADAPTER]
		rename
			make as make_list
		end

feature {NONE} -- Initialization

	make
		local
			adapter: EL_IP_ADAPTER
		do
			make_list (3)
			across new_device_list as device loop
				adapter := device.item.to_adapter
				-- ignore adapters with no hardware address
				if not adapter.had_default_address then
					extend (adapter)
				end
			end
		end

feature {NONE} -- Factory

	new_device_list: EL_NETWORK_DEVICE_LIST_I
		deferred
		end

end
