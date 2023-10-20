note
	description: "Shared access to instance of [$source EL_SERVICE_PORT_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

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
