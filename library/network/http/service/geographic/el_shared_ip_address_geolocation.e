note
	description: "Shared instance of ${EL_IP_ADDRESS_GEOLOCATION_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 14:12:19 GMT (Thursday 11th July 2024)"
	revision: "7"

deferred class
	EL_SHARED_IP_ADDRESS_GEOLOCATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	IP_country_table: EL_IP_ADDRESS_GEOLOCATION_TABLE [EL_IP_ADDRESS_COUNTRY]
		once
			create Result.make (11)
		end

	IP_country_region_table: EL_IP_ADDRESS_GEOLOCATION_TABLE [EL_IP_ADDRESS_COUNTRY_REGION]
		once
			create Result.make (11)
		end

end