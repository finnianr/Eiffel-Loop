note
	description: "[
		Adapter type constants based on Windows API `IfType' in `struct _IP_ADAPTER_ADDRESSES'

		[http://msdn.microsoft.com/en-us/library/windows/desktop/aa366058%28v=vs.85%29.aspx See Microsoft MSDN article]

		Shared with Unix implementations
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 11:43:12 GMT (Sunday 16th July 2023)"
	revision: "9"

class
	EL_NETWORK_DEVICE_TYPE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			foreign_naming as Snake_case_upper
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
			USB_IEEE80211 := 72
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

	USB_IEEE80211: NATURAL_8
		-- An IEEE 802.11 wireless USB network interface.
		-- An extra category not in Windows or Unix

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end

end