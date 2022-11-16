note
	description: "Timed procedure main thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

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