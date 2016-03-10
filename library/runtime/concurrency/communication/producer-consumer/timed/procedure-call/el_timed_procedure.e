note
	description: "Summary description for {EL_TIMED_PROCEDURE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_TIMED_PROCEDURE [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_COUNT_CONSUMER
		rename
			stop as stop_consumer,
			launch as launch_consumer
		end

	EL_SHARED_THREAD_MANAGER
		undefine
			default_create
		end

feature {NONE} -- Initialization

	make (a_procedure: like procedure; interval_millisecs: INTEGER)
			--
		do
			default_create
			procedure := a_procedure
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

	procedure: PROCEDURE [BASE_TYPE, OPEN_ARGS]

end
