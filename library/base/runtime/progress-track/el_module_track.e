note
	description: "[
		Shared access to instances of classes:
			
			${EL_PROGRESS_TRACKING}
			${EL_CONSOLE_PROGRESS_DISPLAY}
			${EL_DEFAULT_PROGRESS_DISPLAY}

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "6"

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