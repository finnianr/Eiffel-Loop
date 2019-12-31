note
	description: "Shared instance of [$source EL_LOG_COMMAND_OPTIONS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-31 9:16:08 GMT (Tuesday 31st December 2019)"
	revision: "1"

deferred class
	EL_SHARED_LOG_OPTION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Log_option: EL_LOG_COMMAND_OPTIONS
		once
			create Result.make
		end
end
