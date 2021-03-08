note
	description: "Timed procedure main thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 10:50:38 GMT (Saturday 6th March 2021)"
	revision: "6"

class
	EL_TIMED_PROCEDURE_MAIN_THREAD

inherit
	EL_TIMED_PROCEDURE
		undefine
			stop_consumer
		redefine
			make_default
		end

	EL_COUNT_CONSUMER_MAIN_THREAD
		rename
			stop as stop_consumer,
			launch as launch_consumer
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_COUNT_CONSUMER_MAIN_THREAD}
			Precursor {EL_TIMED_PROCEDURE}
		end
end