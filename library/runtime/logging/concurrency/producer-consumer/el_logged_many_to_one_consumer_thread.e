note
	description: "Logged many to one consumer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_LOGGED_MANY_TO_ONE_CONSUMER_THREAD [P]

inherit
	EL_MANY_TO_ONE_CONSUMER_THREAD [P]
		undefine
			set_waiting, on_continue, on_start
		redefine
			consume_next_product
		end

	EL_LOGGED_CONSUMER_THREAD [P]
		rename
			make as make_consumer
		undefine
			consume_next_product, on_stopping, is_product_available
		end

feature {NONE} -- Implementation

	 consume_next_product
			--
		do
			log.enter ("consume_next_product")
			consume_product
			available_consumers.put (Current)
			log.put_integer_field ("available_consumers.count", available_consumers.count)
			log.put_new_line

			log.put_line ("Notifying delegator")
			-- Notify the delegator that current consumer is available for
			-- another request
			consumption_delegator_thread.notify
			previous_call_is_thread_signal
-- THREAD SIGNAL
			log.exit
		end
end