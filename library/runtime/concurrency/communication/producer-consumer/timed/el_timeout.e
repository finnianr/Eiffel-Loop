note
	description: "Repeatedly puts timer event onto a thread queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-03 14:04:02 GMT (Saturday 3rd April 2021)"
	revision: "5"

class
	EL_TIMEOUT

inherit
	EL_RHYTHMIC_ACTION_THREAD
		redefine
			execute
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
			create event_queue.make (10)
			create timer.make
		end

feature -- Access

	count: INTEGER

	event_queue: EL_THREAD_PRODUCT_QUEUE [TUPLE [INTEGER]]

feature -- Basic operations

	loop_action
			--
		do
			if count > 0 then
				timer.update
				event_queue.put ([timer.elapsed_millisecs.rounded])
				on_post_event
			end
			count := count + 1
		end

feature {NONE} -- Event handling

	on_post_event
		do
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