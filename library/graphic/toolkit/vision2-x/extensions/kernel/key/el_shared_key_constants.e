note
	description: "Shared instance of ${EV_KEY_CONSTANTS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-28 12:28:43 GMT (Sunday 28th January 2024)"
	revision: "10"

deferred class
	EL_SHARED_KEY_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Key: EV_KEY_CONSTANTS
		once
			create Result
		end

end