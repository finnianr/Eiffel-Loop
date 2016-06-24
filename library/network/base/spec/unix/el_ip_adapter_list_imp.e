note
	description: "Unix implementation of `EL_IP_ADAPTER_LIST_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-21 11:06:53 GMT (Tuesday 21st June 2016)"
	revision: "4"

class
	EL_IP_ADAPTER_LIST_IMP

inherit
	EL_IP_ADAPTER_LIST_I
		export
			{NONE} all
		end

	EL_IP_ADAPTER_CONSTANTS
		undefine
			copy, is_equal
		end

	EL_OS_IMPLEMENTATION
		undefine
			copy, is_equal
		end

	EL_MODULE_COMMAND
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	initialize
		local
			ip_adapter: EL_IP_ADAPTER; ip_adapter_info: like Command.new_ip_adapter_info
			type: INTEGER
		do
			ip_adapter_info := Command.new_ip_adapter_info
			across ip_adapter_info.adapters as adapter loop
				if adapter.item.type.same_string ("Wired") then
					type := Type_ETHERNET_CSMACD
				elseif adapter.item.type.starts_with (Version_802_11) then
					type := Type_IEEE80211
				else
					type := Type_OTHER
				end
				create ip_adapter.make (type, adapter.item.name, adapter.item.type, adapter.item.address)
				extend (ip_adapter)
			end
		end

feature {NONE} -- Constants

	Version_802_11: ZSTRING
		once
			Result := "802.11"
		end

end
