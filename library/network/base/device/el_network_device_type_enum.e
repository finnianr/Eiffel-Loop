note
	description: "[
		Adapter type constants based on Windows API `IfType' in `struct _IP_ADAPTER_ADDRESSES'

		[http://msdn.microsoft.com/en-us/library/windows/desktop/aa366058%28v=vs.85%29.aspx See Microsoft MSDN article]

		Shared with Unix implementations
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 8:28:10 GMT (Tuesday 28th April 2020)"
	revision: "4"

class
	EL_NETWORK_DEVICE_TYPE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as to_snake_case_upper,
			import_name as from_snake_case_upper
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			ATM := 37
			BLUETOOTH := 7 -- Extra identifier not in Microsoft API

			ETHERNET_CSMACD := 6
			IEEE1394 := 144
			IEEE80211 := 71
			ISO88025_TOKENRING := 9
			OTHER := 1
			PPP := 23
			SOFTWARE_LOOPBACK := 24
			TUNNEL := 131
		end

feature -- Access

	ATM: NATURAL_8
		-- An ATM network interface.

	BLUETOOTH: NATURAL_8
		-- Extra identifier not in Microsoft API

	ETHERNET_CSMACD: NATURAL_8
		-- An Ethernet network interface.

	IEEE1394: NATURAL_8
		-- An IEEE 1394 (Firewire) high performance serial bus network interface.

	IEEE80211: NATURAL_8
		-- An IEEE 802.11 wireless network interface.
		-- On Windows Vista and later, wireless network cards are reported as IF_TYPE_IEEE80211.
		-- On earlier versions of Windows, wireless network cards are reported as IF_TYPE_ETHERNET_CSMACD.

	ISO88025_TOKENRING: NATURAL_8
		-- A token ring network interface.

	OTHER: NATURAL_8
		-- Some other type of network interface.

	PPP: NATURAL_8
		-- A PPP network interface.

	SOFTWARE_LOOPBACK: NATURAL_8
		-- A software loopback network interface.

	TUNNEL: NATURAL_8
		-- A tunnel type encapsulation network interface.

feature -- Conversion

	from_linux (type: STRING): NATURAL_8
		-- convert from type shown in output of Linux `nmcli' command
		do
			if type.has_substring ("bluetooth") then
				Result := BLUETOOTH
			elseif type.has_substring ("ethernet") then
				Result := ETHERNET_CSMACD
			elseif type.has_substring ("wireless") then
				Result := IEEE80211
			else
				Result := OTHER
			end
		end

end
