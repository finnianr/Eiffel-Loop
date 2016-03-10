note
	description: "Repeatedly puts timer event onto a thread queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_TIMEOUT

inherit
	EL_RHYTHMIC_ACTION_THREAD
		redefine
			execute
		end

	EL_MODULE_LOG
		undefine
			default_create, is_equal, copy
		end

create
	make_with_interval

feature {NONE} -- Initialization

	make_with_interval (an_interval: INTEGER)
			-- Create with `an_interval' in milliseconds.
		require
			an_interval_not_negative: an_interval >= 0
		do
			make (an_interval)
			create event_queue.make
			create timer.make
		end

feature -- Access

	event_queue: EL_THREAD_PRODUCT_QUEUE [TUPLE [INTEGER]]

	count: INTEGER

feature -- Basic operations

	loop_action
			--
		do
			log.enter ("do_action")
			if count > 0 then
				timer.update
				event_queue.put ([timer.elapsed_millisecs])
				log.put_integer_field ("Elapsed time", timer.elapsed_millisecs)
				log.put_new_line
			end
			count := count + 1
			log.exit
		end

feature {NONE} -- Implementation

	execute
			--
		do
			timer.start
			Precursor
		end

	timer: EL_EXECUTION_TIMER

end
