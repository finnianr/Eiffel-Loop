note
	description: "Shared global instance of ${Default_listener}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "2"

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