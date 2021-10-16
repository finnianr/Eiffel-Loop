note
	description: "[
		Cached table of geographic locations for IP address accessible via
		[$source EL_SHARED_IP_ADDRESS_GEO_LOCATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-14 11:48:02 GMT (Thursday 14th October 2021)"
	revision: "1"

class
	EL_IP_ADDRESS_GEOLOCATION_TABLE

inherit
	EL_CACHE_TABLE [ZSTRING, NATURAL]
		rename
			make as make_cache
		end

	EL_IP_ADDRESS_INFO_FACTORY [EL_IP_ADDRESS_GEOLOCATION]

create
	make

feature {NONE} -- Initialization

	make
		do
			make_cache (11, agent new_location)
			create location_table.make (19)
		end

feature {NONE} -- Implementation

	new_location (ip_number: NATURAL): ZSTRING
		do
			if attached new_info (ip_number) as info then
				location_table.put (info.location)
				Result := location_table.found_item
			end
		end

feature {NONE} -- Internal attributes

	location_table: EL_HASH_SET [ZSTRING]
end