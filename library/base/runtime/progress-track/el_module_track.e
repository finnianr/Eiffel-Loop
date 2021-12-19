note
	description: "[
		Shared access to instances of classes:
			
			[$source EL_PROGRESS_TRACKING]
			[$source EL_CONSOLE_PROGRESS_DISPLAY]
			[$source EL_DEFAULT_PROGRESS_DISPLAY]

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-07 18:15:59 GMT (Tuesday 7th December 2021)"
	revision: "4"

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