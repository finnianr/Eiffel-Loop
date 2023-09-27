note
	description: "[
		Interface to API `<network-adapter.h>' as a bridge to 
		[https://learn.microsoft.com/en-us/windows/win32/api/iphlpapi/ IP helper API] `<iphlpapi.h>'
		
		Location:
		
			C_library\network-adapter\source\network-adapter.h
	]"
	notes: "[
		It may be possible to implement this using inline externals and only using these lines
		in network-adapter.h.
		
			#include <winsock2.h>
			#include <WS2tcpip.h>
			#include <iphlpapi.h>
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_NETWORK_ADAPTER_C_API

inherit
	EL_C_API

feature {NONE} -- Adaptor list

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

feature {NONE} -- Adapter attributes

	c_get_adapter_description (adapter_ptr: POINTER): POINTER
		require
			is_ptr_adapter_attached: is_attached (adapter_ptr)
		external
			"C (EIF_POINTER): EIF_POINTER | <network-adapter.h>"
		alias
			"get_adapter_description"
		end

	c_get_adapter_name (adapter_ptr: POINTER): POINTER
		require
			is_ptr_adapter_attached: is_attached (adapter_ptr)
		external
			"C (EIF_POINTER): EIF_POINTER | <network-adapter.h>"
		alias
			"get_adapter_name"
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

	c_get_adapter_type (adapter_ptr: POINTER): INTEGER
		require
			is_ptr_adapter_attached: is_attached (adapter_ptr)
		external
			"C (EIF_POINTER): EIF_INTEGER | <network-adapter.h>"
		alias
			"get_adapter_type"
		end

feature {NONE} -- Macro constants

	c_error_buffer_overflow: INTEGER
			--
		external
			"C [macro <Iphlpapi.h>]"
		alias
			"ERROR_BUFFER_OVERFLOW"
		end

end
