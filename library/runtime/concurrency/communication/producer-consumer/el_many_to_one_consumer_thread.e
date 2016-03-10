note
	description: "Summary description for {EL_MANY_TO_ONE_CONSUMER_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_MANY_TO_ONE_CONSUMER_THREAD [P]

inherit
	EL_CONSUMER_THREAD [P]
		rename
			make as make_consumer
		redefine
			consume_next_product, on_stopping, is_product_available
		end

feature {NONE} -- Initialization

	make (
		a_consumption_delegator_thread: like consumption_delegator_thread
		a_available_consumers: like available_consumers
	)
			--
		do
			make_consumer
			consumption_delegator_thread := a_consumption_delegator_thread
			available_consumers := a_available_consumers
		end

feature {EL_DELEGATING_CONSUMER_THREAD} -- Element change

	set_product (a_product: like product)
			--
		do
			product := a_product
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

	on_stopping
			--
		do
			consumption_delegator_thread.notify
			previous_call_is_thread_signal
-- THREAD SIGNAL
		end

	is_product_available: BOOLEAN = true

	consumption_delegator_thread: EL_EVENT_LISTENER

	available_consumers: EL_THREAD_SAFE_STACK [like Current]

end
