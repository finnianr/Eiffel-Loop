note
	description: "Logged version of [$source EL_FILE_PROCESS_THREAD]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_LOGGED_FILE_PROCESS_THREAD

inherit
	EL_FILE_PROCESS_THREAD
		redefine
			on_start
		end

	EL_MODULE_LOG_MANAGER

create
	make

feature {NONE} -- Implementation

	on_start
		do
			Log_manager.add_thread (Current)
		end

end