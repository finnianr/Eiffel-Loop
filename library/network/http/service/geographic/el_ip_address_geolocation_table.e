note
	description: "[
		Cached table of geographic locations for IP address accessible via
		${EL_SHARED_IP_ADDRESS_GEOLOCATION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:37:16 GMT (Monday 25th December 2023)"
	revision: "5"

class
	EL_IP_ADDRESS_GEOLOCATION_TABLE

inherit
	EL_CACHE_TABLE [ZSTRING, NATURAL]
		rename
			new_item as new_location
		redefine
			make
		end

	EL_IP_ADDRESS_INFO_FACTORY [EL_IP_ADDRESS_GEOLOCATION]

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
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