note
	description: "Shared global instance of ${EL_DEFAULT_EVENT_LISTENER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-01 12:10:12 GMT (Monday 1st April 2024)"
	revision: "3"

deferred class
	EL_SHARED_DEFAULT_LISTENER

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Default_listener: EL_DEFAULT_EVENT_LISTENER
		once ("PROCESS")
			create Result
		end

end