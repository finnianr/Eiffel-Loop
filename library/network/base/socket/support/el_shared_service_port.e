note
	description: "Shared access to instance of [$source EL_SERVICE_PORT_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-19 9:18:23 GMT (Thursday 19th October 2023)"
	revision: "4"

deferred class
	EL_SHARED_SERVICE_PORT

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Service_port: EL_SERVICE_PORT_ENUM
		once
			create Result.make
		end
end