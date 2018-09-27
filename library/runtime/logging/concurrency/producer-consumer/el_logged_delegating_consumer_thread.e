note
	description: "Logged delegating consumer thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_LOGGED_DELEGATING_CONSUMER_THREAD  [P, CONSUMER_TYPE -> EL_MANY_TO_ONE_CONSUMER_THREAD [P] create make end]

inherit
	EL_DELEGATING_CONSUMER_THREAD [P, CONSUMER_TYPE]
		undefine
			set_waiting, on_continue, on_start
		redefine
			delegate_consumption_of_next_product, on_stopping, product_queue
		end

	EL_LOGGED_CONSUMER_THREAD [P]
		rename
			consume_product as delegate_consumption_of_next_product,
			is_waiting as is_waiting_for_new_queue_item
		undefine
			make_default, stop, on_stopping
		redefine
			product_queue
		end

create
	make

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
				consumer_delegate := new_consumer_delegate
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

feature {NONE} -- Internal attributes

	product_queue: EL_ONE_TO_MANY_THREAD_PRODUCT_QUEUE [P, CONSUMER_TYPE]

end