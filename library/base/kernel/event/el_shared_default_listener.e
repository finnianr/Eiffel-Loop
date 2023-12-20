note
	description: "Shared global instance of [$source Default_listener]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-27 13:17:32 GMT (Monday 27th November 2023)"
	revision: "1"

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