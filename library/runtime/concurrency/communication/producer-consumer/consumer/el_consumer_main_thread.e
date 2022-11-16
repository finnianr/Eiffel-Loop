note
	description: "Product consumer operating in main message_loop_callback GUI thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_CONSUMER_MAIN_THREAD [P]

inherit
	EL_CONSUMER [P]
		redefine
			stop
		end

	EL_EVENT_LISTENER
		rename
			notify as execute
		export
			{NONE} all
		end

	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE

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