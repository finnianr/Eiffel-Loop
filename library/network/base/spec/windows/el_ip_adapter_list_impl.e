note
	description: "Summary description for {EL_IP_ADAPTER_LIST_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 11:47:44 GMT (Wednesday 24th June 2015)"
	revision: "3"

class
	EL_IP_ADAPTER_LIST_IMPL

inherit
	EL_PLATFORM_IMPL
		redefine
			interface
		end

	EL_MEMORY

	EL_SHARED_C_WIDE_CHARACTER_STRING

	EL_IP_ADAPTER_CONSTANTS

create
	make

feature -- Access

	list: LINKED_LIST [EL_IP_ADAPTER]
		local
			buffer: MANAGED_POINTER
			buffer_size, try_count: INTEGER
			done: BOOLEAN
			adapter_ptr: POINTER
		do
			from buffer_size := Default_buffer_size until done or try_count = 3 loop
				create buffer.make (buffer_size)
				if c_get_adapter_addresses (buffer.item, $buffer_size) = c_error_buffer_overflow then
					buffer_size := buffer_size * 3 // 2
					try_count := try_count + 1
				else
					done := True
				end
			end
			create Result.make
			if done then
				from adapter_ptr := buffer.item until adapter_ptr = Default_pointer loop
					Result.extend (new_adapter (adapter_ptr))
					adapter_ptr := c_get_next_adapter (adapter_ptr)
				end
			end
		end

feature {NONE} -- Implementation

	interface: EL_IP_ADAPTER_LIST

	new_adapter (adapter_ptr: POINTER): EL_IP_ADAPTER
		local
			physical_address: ARRAY [NATURAL_8]
			address_size, type: INTEGER
			name, description: EL_ASTRING
		do
			address_size := c_get_adapter_physical_address_size (adapter_ptr)
			if address_size > 0 then
				create physical_address.make (1, address_size)
				physical_address.area.base_address.memory_copy (
					c_get_adapter_physical_address (adapter_ptr), physical_address.count
				)
			else
				create physical_address.make_filled (0, 1, 6)
			end
			name := wide_string (c_get_adapter_name (adapter_ptr))
			description := wide_string (c_get_adapter_description (adapter_ptr))
			type := c_get_adapter_type (adapter_ptr)
			if type = Type_ETHERNET_CSMACD and then name.starts_with ("Bluetooth") then
				-- What happens if locale is not English?
				type := Type_BLUETOOTH
			end
			create Result.make (type, name, description, physical_address)
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

	c_get_adapter_name (adapter_ptr: POINTER): POINTER
		require
			is_ptr_adapter_attached: is_attached (adapter_ptr)
		external
			"C (EIF_POINTER): EIF_POINTER | <network-adapter.h>"
		alias
			"get_adapter_name"
		end

	c_get_adapter_description (adapter_ptr: POINTER): POINTER
		require
			is_ptr_adapter_attached: is_attached (adapter_ptr)
		external
			"C (EIF_POINTER): EIF_POINTER | <network-adapter.h>"
		alias
			"get_adapter_description"
		end

	c_get_adapter_type (adapter_ptr: POINTER): INTEGER
		require
			is_ptr_adapter_attached: is_attached (adapter_ptr)
		external
			"C (EIF_POINTER): EIF_INTEGER | <network-adapter.h>"
		alias
			"get_adapter_type"
		end

	c_get_adapter_physical_address (adapter_ptr: POINTER): POINTER
		require
			is_ptr_adapter_attached: is_attached (adapter_ptr)
		external
			"C (EIF_POINTER): EIF_POINTER | <network-adapter.h>"
		alias
			"get_adapter_physical_address"
		end

	c_get_adapter_physical_address_size (adapter_ptr: POINTER): INTEGER
		require
			is_ptr_adapter_attached: is_attached (adapter_ptr)
		external
			"C (EIF_POINTER): EIF_INTEGER | <network-adapter.h>"
		alias
			"get_adapter_physical_address_size"
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
