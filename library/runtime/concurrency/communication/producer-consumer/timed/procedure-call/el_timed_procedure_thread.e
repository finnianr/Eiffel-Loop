note
	description: "Timed procedure thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 13:03:22 GMT (Saturday 6th March 2021)"
	revision: "7"

class
	EL_TIMED_PROCEDURE_THREAD

inherit
	EL_TIMED_PROCEDURE
		undefine
			stop_consumer, name, make_default
		end

	EL_COUNT_CONSUMER_THREAD
		rename
			stop as stop_consumer,
			launch as launch_consumer
		end

create
	make

end