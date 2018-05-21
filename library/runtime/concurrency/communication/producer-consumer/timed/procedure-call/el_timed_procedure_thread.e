note
	description: "Timed procedure thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_TIMED_PROCEDURE_THREAD  [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

inherit
	EL_TIMED_PROCEDURE [BASE_TYPE, OPEN_ARGS]
		undefine
			is_equal, copy, stop_consumer, name
		redefine
			make, make_default
		end

	EL_COUNT_CONSUMER_THREAD
		rename
			make as make_consumer,
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
			Precursor {EL_TIMED_PROCEDURE}
			Precursor {EL_COUNT_CONSUMER_THREAD}
		end

	make (a_procedure: like procedure; interval_millisecs: INTEGER)
		do
			Precursor (a_procedure, interval_millisecs)
			create product_count.make (0)
		end
end