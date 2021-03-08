note
	description: "[
		Thread that delegates the work of processing items in a work queue to a pool of
		consumer threads.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 16:59:12 GMT (Saturday 6th March 2021)"
	revision: "6"

deferred class
	EL_MANY_TO_ONE_CONSUMER_THREAD [P]

inherit
	EL_CONSUMER_THREAD [P]
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
			make_default
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
			consume_product
			available_consumers.put (Current)
			-- Notify the delegator that current consumer is available for
			-- another request
			consumption_delegator_thread.notify
			previous_call_is_thread_signal
-- THREAD SIGNAL
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