note
	description: "Windows implementation of [$source EL_NETWORK_DEVICE_LIST_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_NETWORK_DEVICE_LIST_IMP

inherit
	EL_NETWORK_DEVICE_LIST_I
		export
			{NONE} all
		end

	EL_C_API_ROUTINES
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_OS_IMPLEMENTATION
		undefine
			copy, is_equal
		end

	EL_MODULE_EXCEPTION

create
	make

feature {NONE} -- Initialization

	make
		local
			next_ptr: POINTER; read: BOOLEAN
		do
			make_list (10)
			across Address_buffer_sizes as size until read loop
				adapter_buffer := new_adapter_buffer (size.item)
				read := adapter_buffer /= Default_buffer
			end
			if read then
				from next_ptr := adapter_buffer.item until not is_attached (next_ptr) loop
					extend (create {EL_NETWORK_DEVICE_IMP}.make (next_ptr))
					last.set_type_enum_id
					next_ptr := c_get_next_adapter (next_ptr)
				end
			else
				Exception.raise_developer (
					"Buffer allocation of %S insufficient for network adapter addresses",
					[Address_buffer_sizes [Address_buffer_sizes.count]]
				)
			end
		end

feature {NONE} -- Factory

	new_adapter_buffer (size: INTEGER): MANAGED_POINTER
		do
			create Result.make (size)
			if c_get_adapter_addresses (Result.item, $size) = error_buffer_overflow then
				Result := Default_buffer
			end
		end

feature {NONE} -- Internal attributes

	adapter_buffer: MANAGED_POINTER

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

	error_buffer_overflow: INTEGER
			--
		external
			"C [macro <Iphlpapi.h>]"
		alias
			"ERROR_BUFFER_OVERFLOW"
		end

feature {NONE} -- Constants

	Address_buffer_sizes: ARRAY [INTEGER]
		once
			Result := << 15_000, 20_000, 25_000 >>
		end

	Default_buffer: MANAGED_POINTER
		once
			create Result.share_from_pointer (default_pointer, 0)
		end

end