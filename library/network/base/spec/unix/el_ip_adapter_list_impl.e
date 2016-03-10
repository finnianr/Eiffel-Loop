note
	description: "Summary description for {EL_IP_ADAPTER_LIST_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-11 13:09:18 GMT (Thursday 11th September 2014)"
	revision: "2"

class
	EL_IP_ADAPTER_LIST_IMPL

inherit
	EL_PLATFORM_IMPL
		redefine
			interface
		end

	EL_IP_ADAPTER_CONSTANTS

create
	make

feature -- Access

	list: LINKED_LIST [EL_IP_ADAPTER]
		local
			ip_adapter: EL_IP_ADAPTER
			ip_adapter_info: EL_IP_ADAPTER_INFO_COMMAND
			type: INTEGER
		do
			create Result.make
			create ip_adapter_info.make
			across ip_adapter_info.adapters as adapter loop
				if adapter.item.type.same_string ("Wired") then
					type := Type_ETHERNET_CSMACD
				elseif adapter.item.type.starts_with ("802.11") then
					type := Type_IEEE80211
				else
					type := Type_OTHER
				end
				create ip_adapter.make (type, adapter.item.name, adapter.item.type, adapter.item.address)
				Result.extend (ip_adapter)
			end
		end

feature {NONE} -- Implementation

	interface: EL_IP_ADAPTER_LIST

end
