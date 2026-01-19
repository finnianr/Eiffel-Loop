note
	description: "[
		Interface to [https://learn.microsoft.com/en-us/windows/win32/api/iphlpapi/ IP helper API]: `<iphlpapi.h>'
	]"
	notes: "[
		NOT COMPILING
		A clue for the problem is in the forum discussion at
		https://microsoft.public.vc.language.narkive.com/fgY8cPym/c2065-undeclared-identifiers-using-iphlpapi-h
		Looks like i will have not choice but to continue with my bridging library.
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
			attached_arguments: is_attached (address_buffer) and  is_attached (buffer_size)
		external
			"C inline use <iphlpapi.h>"
		alias
			"GetAdaptersAddresses (0, GAA_FLAG_INCLUDE_PREFIX, NULL, (PIP_ADAPTER_ADDRESSES) $address_buffer, (PULONG)$buffer_size)"
		end

feature {NONE} -- Adapter attributes

feature {NONE} -- Macro constants


end
