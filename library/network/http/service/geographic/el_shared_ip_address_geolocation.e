note
	description: "Shared instance of ${EL_IP_ADDRESS_GEOLOCATION_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:38:01 GMT (Monday 25th December 2023)"
	revision: "5"

deferred class
	EL_SHARED_IP_ADDRESS_GEOLOCATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	IP_location_table: EL_IP_ADDRESS_GEOLOCATION_TABLE
		once
			create Result.make (11)
		end
end