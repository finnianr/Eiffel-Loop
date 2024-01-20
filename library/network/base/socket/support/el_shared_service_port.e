note
	description: "Shared access to instance of ${EL_SERVICE_PORT_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

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