note
	description: "Timed procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_TIMED_PROCEDURE

inherit
	EL_COUNT_CONSUMER
		rename
			stop as stop_consumer,
			launch as launch_consumer
		end

	EL_SHARED_THREAD_MANAGER

feature {NONE} -- Initialization

	make (a_procedure: like procedure; interval_millisecs: INTEGER)
			--
		do
			procedure := a_procedure
			make_default
			create timer.make (Current, interval_millisecs)
			thread_manager.extend (Current)
		end

feature -- Basic oerations

	launch
			--
		do
			timer.launch
			launch_consumer
		end

	stop
			--
		do
			timer.stop
			stop_consumer
		end

feature {NONE} -- Implementation

	consume_count
			--
		do
			procedure.apply
		end

	timer: EL_TIMED_COUNT_PRODUCER

	procedure: PROCEDURE

end