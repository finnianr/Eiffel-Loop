note
	description: "[
		Table of ${EL_IP_ADDRESS_GEOGRAPHIC_INFO} objects for IP address keys.
		Accessible via ${EL_SHARED_GEOGRAPHIC_INFO_TABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "7"

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