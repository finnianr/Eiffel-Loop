note
	description: "[
		Adapter type constants based on Windows API IfType in struct _IP_ADAPTER_ADDRESSES
		
		http://msdn.microsoft.com/en-us/library/windows/desktop/aa366058%28v=vs.85%29.aspx
		
		Shared with Unix implementations
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_IP_ADAPTER_CONSTANTS

feature {NONE} -- Constants

	Type_OTHER: INTEGER = 1

	Type_ETHERNET_CSMACD: INTEGER = 6

	Type_BLUETOOTH: INTEGER = 7
		-- Extra identifier not in Microsoft API

	Type_ISO88025_TOKENRING: INTEGER = 9

	Type_PPP: INTEGER = 23

	Type_SOFTWARE_LOOPBACK: INTEGER = 24

	Type_ATM: INTEGER = 37

	Type_IEEE80211: INTEGER = 71

	Type_TUNNEL: INTEGER = 131

	Type_IEEE1394: INTEGER = 144

end
