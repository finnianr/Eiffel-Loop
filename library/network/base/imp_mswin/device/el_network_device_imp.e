note
	description: "Windows implementation of [$source EL_NETWORK_DEVICE_I]"
	notes: "[
		**Example USB wireless adapter**
		
			Wireless LAN adapter Wireless Network Connection 3:

			   Media State . . . . . . . . . . . : Media disconnected
			   Connection-specific DNS Suffix  . :
			   Description . . . . . . . . . . . : FRITZ!WLAN USB Stick AC 860
			   Physical Address. . . . . . . . . : 7C-DD-90-65-98-47
			   DHCP Enabled. . . . . . . . . . . : Yes
			   Autoconfiguration Enabled . . . . : Yes
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_NETWORK_DEVICE_IMP

inherit
	EL_NETWORK_DEVICE_I

	EL_OS_IMPLEMENTATION

	EL_C_OBJECT
		rename
			make_from_pointer as make
		end

	EL_NETWORK_ADAPTER_C_API

	EL_SHARED_C_WIDE_CHARACTER_STRING

	EL_SHARED_NETWORK_DEVICE_TYPE

	EL_MODULE_TUPLE

create
	make

feature -- Access

	address: ARRAY [NATURAL_8]
		do
			if size_of_address = 6 then
				Result := adapter_physical_address.read_array (0, size_of_address)
			else
				create Result.make_filled (0, 1, 6)
			end
		end

	description: ZSTRING
		do
			Result := wide_string (c_get_adapter_description (self_ptr))
		end

	name: ZSTRING
		do
			Result := wide_string (c_get_adapter_name (self_ptr))
		end

feature -- Status change

	set_type_enum_id
		do
			if type = Network_device_type.ETHERNET_CSMACD then
				-- What happens if locale is not English?
				if name.as_lower.has_substring (Protocol.bluetooth) then
					type_enum_id := Network_device_type.BLUETOOTH
				elseif description.as_lower.has_substring (Protocol.usb) then
					type_enum_id := Network_device_type.USB_IEEE80211
				else
					type_enum_id := type
				end
			else
				type_enum_id := type
			end
		end

feature {NONE} -- Implementation

	adapter_physical_address: MANAGED_POINTER
		do
			create Result.make_from_pointer (c_get_adapter_physical_address (self_ptr), size_of_address)
		end

	size_of_address: INTEGER
		do
			Result := c_get_adapter_physical_address_size (self_ptr)
		end

	type: NATURAL_8
		do
			Result := c_get_adapter_type (self_ptr).to_natural_8
		end

end
