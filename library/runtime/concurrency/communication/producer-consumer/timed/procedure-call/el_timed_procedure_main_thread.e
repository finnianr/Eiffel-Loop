note
	description: "Summary description for {EL_TIMED_PROCEDURE_MAIN_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TIMED_PROCEDURE_MAIN_THREAD [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_TIMED_PROCEDURE [BASE_TYPE, OPEN_ARGS]
		undefine
			stop_consumer
		end

	EL_COUNT_CONSUMER_MAIN_THREAD
		rename
			make as make_consumer,
			stop as stop_consumer,
			launch as launch_consumer
		end

create
	make

end
