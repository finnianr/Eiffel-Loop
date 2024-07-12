note
	description: "[
		Find country name for IP address number, with added region for large countries.
		Accessible via ${EL_MODULE_GEOLOCATION}.Geolocation.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-12 6:29:00 GMT (Friday 12th July 2024)"
	revision: "2"

class
	EL_GEOLOCATION_ROUTINES

inherit
	ANY

	EL_SHARED_IP_ADDRESS_GEOLOCATION

	EL_SHARED_PROGRESS_LISTENER

feature -- Basic operations

	store (dir_path: DIR_PATH)
		do
			across table_array as table loop
				table.item.store (dir_path)
			end
		end

	try_restore (dir_path: DIR_PATH)
		do
			across table_array as table loop
				table.item.try_restore (dir_path)
			end
		end

feature -- Access

	for_number (ip_number: NATURAL): ZSTRING
		-- `country_name' for `ip_number'
		-- with `region' added for big countries
		do
		-- api.iplocation.net does not have a request limit (July 2024)
			Result := IP_country_table.item (ip_number)

		-- Add region for big countries
			if Big_country_list.has (Result) then
			-- ipapi.co service is free for a limited number of request
				if attached IP_country_region_table.item (ip_number) as location
					and then location.count > 2 -- (", ").count = 2
				then
					Result := location
				end
			end
			progress_listener.notify_tick
		end

feature {NONE} -- Implementation

	table_array: ARRAY [EL_IP_ADDRESS_GEOLOCATION_TABLE [EL_IP_ADDRESS_COUNTRY]]
		do
			Result := << IP_country_table, IP_country_region_table >>
		end

feature {NONE} -- Constants

	Big_country_list: EL_ZSTRING_LIST
		-- from api.iplocation.net
		once
			Result := "China, India, Russian Federation, United States of America"
		end
end