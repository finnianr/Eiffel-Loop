note
	description: "Windows implementation of ${EL_NETWORK_DEVICE_LIST_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-22 8:32:53 GMT (Wednesday 22nd November 2023)"
	revision: "15"

class
	EL_NETWORK_DEVICE_LIST_IMP

inherit
	EL_NETWORK_DEVICE_LIST_I
		export
			{NONE} all
		end

	EL_NETWORK_ADAPTER_C_API
		undefine
			copy, is_equal
		end

	EL_WINDOWS_IMPLEMENTATION

	EL_MODULE_EXCEPTION

create
	make

feature {NONE} -- Initialization

	make
		local
			next_ptr: POINTER; trial_buffer: MANAGED_POINTER; size: INTEGER
		do
			make_list (10)
			from size := Minimum_buffer_size until attached adapter_buffer or else size > Maximum_buffer_size loop
				create trial_buffer.make (size)
				if c_get_adapter_addresses (trial_buffer.item, $size) /= Error_buffer_overflow then
					adapter_buffer := trial_buffer
				end
				size := size + 2000
			end
			if attached adapter_buffer as buffer then
				from next_ptr := buffer.item until not is_attached (next_ptr) loop
					extend (create {EL_NETWORK_DEVICE_IMP}.make (next_ptr))
					next_ptr := c_get_next_adapter (next_ptr)
				end
			else
				Exception.raise_developer (
					"Buffer allocation of %S insufficient for network adapter addresses", [size]
				)
			end
		end

feature {NONE} -- Internal attributes

	adapter_buffer: detachable MANAGED_POINTER

feature {NONE} -- Constants

	Error_buffer_overflow: INTEGER
		once
			Result := c_error_buffer_overflow
		end

	Minimum_buffer_size: INTEGER = 15_000
		-- Recommended buffer size to start

	Maximum_buffer_size: INTEGER = 36_000

end