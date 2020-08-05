note
	description: "Windows implementation of [$source EL_IP_ADAPTER_LIST_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-05 18:59:03 GMT (Wednesday 5th August 2020)"
	revision: "8"

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

create
	make

feature {NONE} -- Factory

	new_device_list: EL_NETWORK_DEVICE_LIST_IMP
		do
			create Result.make
		end

end
