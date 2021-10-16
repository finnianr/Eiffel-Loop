note
	description: "[
		Table of [$source EL_IP_ADDRESS_INFO] objects for IP address keys.
		Accessible via [$source EL_SHARED_IP_ADDRESS_INFO_TABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-14 10:57:15 GMT (Thursday 14th October 2021)"
	revision: "3"

class
	EL_IP_ADDRESS_INFO_TABLE

inherit
	EL_CACHE_TABLE [EL_IP_ADDRESS_INFO, NATURAL]
		rename
			make as make_cache
		end

	EL_IP_ADDRESS_INFO_FACTORY [EL_IP_ADDRESS_INFO]

create
	make

feature {NONE} -- Initialization

	make
		do
			make_cache (11, agent new_info)
		end

end