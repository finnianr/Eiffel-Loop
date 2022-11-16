note
	description: "Shared instance of [$source EL_LOG_COMMAND_OPTIONS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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