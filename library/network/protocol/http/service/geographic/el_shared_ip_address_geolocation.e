note
	description: "Shared instance of [$source EL_IP_ADDRESS_LOCATION_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-14 11:48:52 GMT (Thursday 14th October 2021)"
	revision: "1"

deferred class
	EL_SHARED_IP_ADDRESS_GEOLOCATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	IP_location: EL_IP_ADDRESS_GEOLOCATION_TABLE
		once
			create Result.make
		end
end