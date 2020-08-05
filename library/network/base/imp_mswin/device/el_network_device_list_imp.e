note
	description: "Windows implementation of [$source EL_NETWORK_DEVICE_LIST_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-05 19:17:19 GMT (Wednesday 5th August 2020)"
	revision: "8"

class
	EL_NETWORK_DEVICE_LIST_IMP

inherit
	EL_NETWORK_DEVICE_LIST_I
		export
			{NONE} all
		end

	EL_POINTER_ROUTINES
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_OS_IMPLEMENTATION
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
		local
			buffer: MANAGED_POINTER; next_ptr: POINTER
			buffer_size, try_count: INTEGER; done: BOOLEAN
		do
			make_list (10)
			from buffer_size := Default_buffer_size until done or try_count = 3 loop
				create buffer.make (buffer_size)
				if c_get_adapter_addresses (buffer.item, $buffer_size) = c_error_buffer_overflow then
					buffer_size := buffer_size * 3 // 2
					try_count := try_count + 1
				else
					done := True
				end
			end
			if done then
				from next_ptr := buffer.item until not is_attached (next_ptr) loop
					extend (create {EL_NETWORK_DEVICE_IMP}.make (next_ptr))
					next_ptr := c_get_next_adapter (next_ptr)
				end
			end
		end

feature {NONE} -- C Externals

	c_get_adapter_addresses (address_buffer, buffer_size: POINTER): INTEGER
		require
			is_address_buffer_attached: is_attached (address_buffer)
			is_buffer_size_attached: is_attached (buffer_size)
		external
			"C (EIF_POINTER, EIF_POINTER): EIF_INTEGER | <network-adapter.h>"
		alias
			"get_adapter_addresses"
		end

	c_get_next_adapter (adapter_ptr: POINTER): POINTER
		require
			is_ptr_adapter_attached: is_attached (adapter_ptr)
		external
			"C (EIF_POINTER): EIF_POINTER | <network-adapter.h>"
		alias
			"get_next_adapter"
		end

feature {NONE} -- C constants

	c_error_buffer_overflow: INTEGER
			--
		external
			"C [macro <Iphlpapi.h>]"
		alias
			"ERROR_BUFFER_OVERFLOW"
		end

feature {NONE} -- Constants

	Default_buffer_size: INTEGER = 15000


end
