note
	description: "Product consumer operating in main message_loop_callback GUI thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-23 13:17:12 GMT (Thursday 23rd April 2015)"
	revision: "3"

deferred class
	EL_CONSUMER_MAIN_THREAD [P]

inherit
	EL_CONSUMER [P]
		redefine
			stop
		end

	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE
		export
			{NONE} all
		end

	EL_EVENT_LISTENER
		rename
			notify as execute
		export
			{NONE} all
		end

feature -- Basic operations

	launch
			--
		do
			activate
			prompt
		end

	prompt
			-- do another action
		do
			main_thread_event_request_queue.put (Current)
		end

	stop
			--
		do
			set_stopped
		end

feature {NONE} -- Implementation

	execute
			-- Consumes all available products
		do
			if not is_stopped then
				set_consuming
				from until is_stopped or not is_product_available loop
					consume_next_product
				end
				if not is_stopped then
					set_active
				end
			end
		end

end

