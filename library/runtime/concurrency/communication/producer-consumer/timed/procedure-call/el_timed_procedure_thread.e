note
	description: "Timed procedure thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

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