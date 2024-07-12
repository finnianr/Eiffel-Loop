note
	description: "Shared instance of ${EL_IP_ADDRESS_GEOLOCATION_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-12 6:27:34 GMT (Friday 12th July 2024)"
	revision: "8"

deferred class
	EL_SHARED_IP_ADDRESS_GEOLOCATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	IP_country_table: EL_IP_ADDRESS_GEOLOCATION_TABLE [EL_IP_ADDRESS_COUNTRY]
		-- api.iplocation.net does not have a request limit (July 2024)
		once
			create Result.make (11)
		end

	IP_country_region_table: EL_IP_ADDRESS_GEOLOCATION_TABLE [EL_IP_ADDRESS_COUNTRY_REGION]
		-- ipapi.co service (free for a limited number of requests)
		once
			create Result.make (11)
		end

end