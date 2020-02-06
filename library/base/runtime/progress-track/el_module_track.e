note
	description: "[
		Shared access to routines of class [$source EL_PROGRESS_TRACKER] and [$source EL_CONSOLE_PROGRESS_DISPLAY]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:25:31 GMT (Thursday 6th February 2020)"
	revision: "2"

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

end
