note
	description: "[
		Shared access to routines of class [$source EL_PROGRESS_TRACKER] and [$source EL_CONSOLE_PROGRESS_DISPLAY]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-22 10:57:41 GMT (Monday 22nd March 2021)"
	revision: "3"

deferred class
	EL_MODULE_TRACK

inherit
	EL_MODULE

feature {NONE} -- Constants

	Track: EL_PROGRESS_TRACKING
		once
			create Result
		end

	Console_display: EL_CONSOLE_PROGRESS_DISPLAY
		once
			create Result.make
		end

	Default_display: EL_DEFAULT_PROGRESS_DISPLAY
		once
			create Result
		end

end