note
	description: "Shared instance of [$source EL_IP_ADDRESS_INFO_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-12 15:59:26 GMT (Tuesday 12th October 2021)"
	revision: "2"

deferred class
	EL_SHARED_IP_ADDRESS_INFO_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Internet_address: EL_IP_ADDRESS_INFO_TABLE
		once
			create Result.make
		end
end