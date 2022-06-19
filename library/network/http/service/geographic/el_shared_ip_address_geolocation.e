note
	description: "Shared instance of [$source EL_IP_ADDRESS_GEOLOCATION_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-19 9:27:24 GMT (Sunday 19th June 2022)"
	revision: "3"

deferred class
	EL_SHARED_IP_ADDRESS_GEOLOCATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	IP_location_table: EL_IP_ADDRESS_GEOLOCATION_TABLE
		once
			create Result.make
		end
end