note
	description: "Logged timeout"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-15 9:38:50 GMT (Friday 15th December 2023)"
	revision: "8"

class
	EL_LOGGED_TIMEOUT

inherit
	EL_TIMEOUT
		rename
			on_post_event as  log_event
		undefine
			log_event
		redefine
			on_start
		end

	EL_MODULE_LOG_MANAGER

	EL_MODULE_LOG

	EL_LOGGED_EVENT_COUNTER

create
	make_with_interval

feature {NONE} -- Implemenation

	elapsed_millisecs: INTEGER
		do
			Result := timer.elapsed_millisecs
		end

	on_start
		do
			Log_manager.add_thread (Current)
		end

feature {NONE} -- Constants

	Count_label: ZSTRING
		once
			Result := "Timer event"
		end

end