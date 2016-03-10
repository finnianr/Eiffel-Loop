note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-23 10:26:53 GMT (Thursday 23rd April 2015)"
	revision: "3"

deferred class
	EL_CONSUMER [P]

inherit
	EL_STOPPABLE_THREAD

	EL_THREAD_CONSTANTS

	EL_MODULE_LOG

feature -- Basic operations

	launch
			-- do another action
		deferred
		end

	prompt
			-- do another action
		deferred
		end

feature {EL_THREAD_PRODUCT_QUEUE, EL_DELEGATING_CONSUMER_THREAD} -- Element change

	set_product_queue (a_product_queue: like product_queue)
			--
		do
			product_queue := a_product_queue
		end

feature -- Element change

	disable_logging
			--
		do
			logging_disabled := true
		end

feature -- State change

	set_consuming
			--
		do
			set_state (State_consuming)
		end

	set_waiting
			--
		do
			set_state (State_waiting)
		end

feature -- Query status

	is_consuming: BOOLEAN
			--
		do
			Result := state = State_consuming
		end

	is_waiting: BOOLEAN
			--
		do
			Result := state = State_waiting
		end

	is_product_available: BOOLEAN
			--
		do
			Result := not product_queue.is_empty
		end

feature {NONE} -- Implementation

	execute
			-- Continuous loop to do action that waits to be prompted
		require else
			valid_product_queue: product_queue /= Void
		deferred
		end

	consume_product
			--
		deferred
		end

	consume_next_product
			--
		require
			valid_state: is_consuming
			product_available: is_product_available
		do
			if logging_disabled then
				product := product_queue.removed_item
			else
				log.enter ("consume_product")
				product := product_queue.logged_removed_item
				log.exit
			end
			consume_product
		end

	product: P

	product_queue: EL_THREAD_PRODUCT_QUEUE [P]

	logging_disabled: BOOLEAN

end
