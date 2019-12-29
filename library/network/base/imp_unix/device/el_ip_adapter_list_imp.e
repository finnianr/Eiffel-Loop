note
	description: "Unix implementation of [$source EL_IP_ADAPTER_LIST_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-29 14:27:41 GMT (Sunday 29th December 2019)"
	revision: "6"

class
	EL_IP_ADAPTER_LIST_IMP

inherit
	EL_IP_ADAPTER_LIST_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION
		undefine
			copy, is_equal
		end

	EL_MODULE_COMMAND

	EL_SHARED_NETWORK_DEVICE_TYPE

create
	make

feature {NONE} -- Initialization

	initialize
		local
			ip_adapter: EL_IP_ADAPTER; ip_adapter_info: like Command.new_ip_adapter_info
			type: NATURAL_8
		do
			ip_adapter_info := Command.new_ip_adapter_info
			across ip_adapter_info.adapter_list as adapter loop
				type := Network_device_type.from_linux (adapter.item.type)
				create ip_adapter.make (type, adapter.item.name, adapter.item.description, adapter.item.address)
				extend (ip_adapter)
			end
		end

end
