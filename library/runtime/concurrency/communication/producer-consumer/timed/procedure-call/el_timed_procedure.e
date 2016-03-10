note
	description: "Summary description for {EL_TIMED_PROCEDURE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-25 10:06:00 GMT (Saturday 25th April 2015)"
	revision: "2"

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
			make_default
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
