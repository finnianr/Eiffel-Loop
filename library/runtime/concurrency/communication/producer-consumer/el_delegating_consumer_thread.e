note
	description: "[
		Consumer thread
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 11:45:38 GMT (Sunday 3rd July 2016)"
	revision: "1"

class
	EL_DELEGATING_CONSUMER_THREAD [P, CONSUMER_TYPE -> EL_MANY_TO_ONE_CONSUMER_THREAD [P] create make end]

inherit
	EL_CONSUMER_THREAD [P]
		rename
			consume_product as delegate_consumption_of_next_product,
			is_waiting as is_waiting_for_new_queue_item
		redefine
			make_default, product_queue, on_stopping, stop
		end

	EL_SUSPENDABLE
		undefine
			is_equal, copy
		redefine
			make_default
		end

	EL_EVENT_LISTENER
		rename
			notify as continue_if_waiting_for_consumer
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_SUSPENDABLE}
			Precursor {EL_CONSUMER_THREAD}
		end

feature -- Basic operations

	stop
			--
		local
			state_previous: INTEGER
		do
			state_previous := state
			set_state (State_stopping)
			if is_suspended then
				resume
				previous_call_is_thread_signal
-- THREAD SIGNAL
			elseif state_previous = State_waiting then
				prompt
				previous_call_is_thread_signal
-- THREAD SIGNAL
			end
			across product_queue.all_consumers as consumer loop
				consumer.item.stop
			end
		end

feature {NONE} -- Implementation

	continue_if_waiting_for_consumer
			--
		do
			if is_suspended then
				resume
				previous_call_is_thread_signal
-- THREAD SIGNAL
			end
		end

	new_consumer_delegate: CONSUMER_TYPE
			--
		do
			create Result.make (Current, product_queue.available_consumers)
		end

	delegate_consumption_of_next_product
			--
		local
			consumer_delegate: CONSUMER_TYPE
		do
			if not product_queue.available_consumers.is_empty then

			elseif not product_queue.all_consumers.full then
				consumer_delegate := new_consumer_delegate
				consumer_delegate.set_product_queue (product_queue)
				product_queue.all_consumers.extend (consumer_delegate)
				consumer_delegate.launch
				product_queue.available_consumers.put (consumer_delegate)

			else

				suspend
				Previous_call_is_blocking_thread
-- THREAD WAITING
				if not is_stopping then
					set_state (State_consuming)
				end
			end
			check
				consumer_now_available: not product_queue.available_consumers.is_empty
			end

			if is_consuming then
				consumer_delegate := product_queue.available_consumers.removed_item
				consumer_delegate.set_product (product)
				consumer_delegate.prompt
				Previous_call_is_thread_signal
-- THREAD SIGNAL
			end
		end

	on_stopping
			--
		local
			all_consumers_stopped: BOOLEAN
		do
			from until all_consumers_stopped loop
				if product_queue.available_consumers.count = product_queue.all_consumers.count then
					all_consumers_stopped := true
				else
					suspend
					Previous_call_is_blocking_thread
-- THREAD WAITING
					set_state (State_stopping)
				end
			end
		end

feature {NONE} -- Internal attributes

	product_queue: EL_ONE_TO_MANY_THREAD_PRODUCT_QUEUE [P, CONSUMER_TYPE]

end
