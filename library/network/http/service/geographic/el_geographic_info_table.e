note
	description: "[
		Table of [$source EL_IP_ADDRESS_INFO] objects for IP address keys.
		Accessible via [$source EL_SHARED_IP_ADDRESS_INFO_TABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_GEOGRAPHIC_INFO_TABLE

inherit
	EL_COMPRESSION_TABLE [EL_IP_ADDRESS_GEOGRAPHIC_INFO, NATURAL]
		rename
			at as at_ip,
			item as item_ip
		export
			{NONE} at_ip, item_ip
		end

	EL_IP_ADDRESS_INFO_FACTORY [EL_IP_ADDRESS_GEOGRAPHIC_INFO]

create
	make

feature -- Access

	item (ip: NATURAL): EL_IP_ADDRESS_GEOGRAPHIC_INFO
		do
			if not has_key (ip) then
				put (new_info (ip), ip)
			end
			Result := found_item
		end

end