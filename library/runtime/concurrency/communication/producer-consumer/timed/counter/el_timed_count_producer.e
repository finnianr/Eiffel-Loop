note
	description: "Summary description for {EL_TIMED_COUNT_PRODUCER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_TIMED_COUNT_PRODUCER

inherit
	EL_RHYTHMIC_ACTION_THREAD
		rename
			make as make_thread
		end

	EL_SHARED_THREAD_MANAGER
		undefine
			default_create, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (consumer: EL_COUNT_CONSUMER; interval_millisecs: INTEGER)
			--
		do
			make_thread (interval_millisecs)
			create call_queue.make
			call_queue.attach_consumer (consumer)
			thread_manager.extend (Current)
		end

feature {NONE} -- Implementation

	loop_action
			--
		do
			count := count + 1
			call_queue.put (count)
		end

	call_queue: EL_THREAD_PRODUCT_QUEUE [INTEGER]

	count: INTEGER
end
