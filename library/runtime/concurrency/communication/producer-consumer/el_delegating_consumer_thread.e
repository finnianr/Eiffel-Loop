note
	description: "[
		Consumer thread
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-23 10:34:15 GMT (Thursday 23rd April 2015)"
	revision: "2"

class
	EL_DELEGATING_CONSUMER_THREAD [P, CONSUMER_TYPE -> EL_MANY_TO_ONE_CONSUMER_THREAD [P] create make end]

inherit
	EL_CONSUMER_THREAD [P]
		rename
			consume_product as delegate_consumption_of_next_product,
			is_waiting as is_waiting_for_new_queue_item
		redefine
			make, make_default, product_queue, on_stopping, stop
		end

	EL_SUSPENDABLE_THREAD
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
			Precursor {EL_SUSPENDABLE_THREAD}
			Precursor {EL_CONSUMER_THREAD}
		end

	make
			--
		do
			Precursor
			disable_logging
		end

feature -- Basic operations

	stop
			--
		local
			state_previous: INTEGER
		do
			state_previous := state
			set_state (State_stopping)
			inspect state_previous
				when State_waiting then
					prompt
					previous_call_is_thread_signal
-- THREAD SIGNAL

				when State_suspended then
					resume
					previous_call_is_thread_signal
-- THREAD SIGNAL
				else

			end
			product_queue.all_consumers.do_all (
				agent (consumer: CONSUMER_TYPE) do consumer.stop end
			)

		end

feature {NONE} -- Implementation

	delegate_consumption_of_next_product
			--
		local
			consumer_delegate: CONSUMER_TYPE
		do
			log.enter ("delegate_consumption_of_next_product")
			if not product_queue.available_consumers.is_empty then
				log.put_line ("using available consumer")

			elseif not product_queue.all_consumers.full then
				log.put_line ("creating a new consumer")
				consumer_delegate := create_consumer_delegate
				consumer_delegate.set_product_queue (product_queue)
				product_queue.all_consumers.extend (consumer_delegate)
				consumer_delegate.launch
				product_queue.available_consumers.put (consumer_delegate)

			else
				log.put_line ("waiting for consumer to finish")

				suspend
				Previous_call_is_blocking_thread
-- THREAD WAITING

				log.put_line ("resuming")
				if not is_stopping then
					set_state (State_consuming)
				end
			end
			check
				consumer_now_available: not product_queue.available_consumers.is_empty
			end

			if is_consuming then
				log.put_line ("assigning product to delegate")
				consumer_delegate := product_queue.available_consumers.removed_item
				consumer_delegate.set_product (product)
				consumer_delegate.prompt
				Previous_call_is_thread_signal
-- THREAD SIGNAL
			end
			log.exit
		end

	on_stopping
			--
		local
			all_consumers_stopped: BOOLEAN
		do
			log.enter ("on_stopping")
			from until all_consumers_stopped loop
				log.put_integer_field ("available_consumers.count", product_queue.available_consumers.count)
				log.put_new_line
				log.put_integer_field ("all_consumers.count", product_queue.all_consumers.count)
				log.put_new_line
				if product_queue.available_consumers.count = product_queue.all_consumers.count then
					all_consumers_stopped := true
				else
					log.put_line ("waiting for a consumer to stop")
					suspend
					Previous_call_is_blocking_thread
-- THREAD WAITING
					set_state (State_stopping)
					log.put_line ("a consumer has stopped")
				end
			end
			log.exit
		end

	continue_if_waiting_for_consumer
			--
		do
			if is_suspended then
				resume
				previous_call_is_thread_signal
-- THREAD SIGNAL
			end
		end

	create_consumer_delegate: CONSUMER_TYPE
			--
		do
			create Result.make (Current, product_queue.available_consumers)
		end

	product_queue: EL_ONE_TO_MANY_THREAD_PRODUCT_QUEUE [P, CONSUMER_TYPE]

end
