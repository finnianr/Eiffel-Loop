note
	description: "Consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-20 23:57:36 GMT (Wednesday 20th June 2018)"
	revision: "4"

deferred class
	EL_CONSUMER [P]

inherit
	EL_STOPPABLE_THREAD

	EL_THREAD_CONSTANTS

feature -- Basic operations

	launch
			-- do another action
		deferred
		end

	prompt
			-- do another action
		deferred
		end

feature -- Status setting

	enable_consume_remaining
		do
			consume_remaining_enabled := True
		end

feature -- Status query

	consume_remaining_enabled: BOOLEAN
		-- if True then remaining products in `product_queue' are consumed
		-- after thread `state' is set to `State_stopping'


feature {EL_THREAD_PRODUCT_QUEUE, EL_DELEGATING_CONSUMER_THREAD} -- Element change

	set_product_queue (a_product_queue: like product_queue)
			--
		do
			product_queue := a_product_queue
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
			product := product_queue.removed_item
			consume_product
		end

	product: P

	product_queue: EL_THREAD_PRODUCT_QUEUE [P]

end
