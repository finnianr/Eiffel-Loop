note
	description: "[
		Consumer of products placed by a separate thread into the queue:
		
			product_queue: ${EL_THREAD_PRODUCT_QUEUE [P]}
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

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

	is_product_available: BOOLEAN
			--
		do
			Result := not product_queue.is_empty
		end

	is_waiting: BOOLEAN
			--
		do
			Result := state = State_waiting
		end

feature {NONE} -- Implementation

	consume_next_product
			--
		require
			valid_state: is_consuming
			product_available: is_product_available
		do
			product := product_queue.removed_item
			consume_product
		end

	consume_product
			--
		deferred
		end

	execute
			-- Continuous loop to do action that waits to be prompted
		deferred
		end

feature {NONE} -- Internal attributes

	product: P

	product_queue: EL_THREAD_PRODUCT_QUEUE [P];

note
	descendants: "[
			EL_CONSUMER* [P]
				${EL_NONE_CONSUMER [P]}
				${EL_COUNT_CONSUMER}*
					${EL_COUNT_CONSUMER_MAIN_THREAD}*
						${EL_TIMED_PROCEDURE_MAIN_THREAD}
					${EL_TIMED_PROCEDURE}*
						${EL_TIMED_PROCEDURE_MAIN_THREAD}
						${EL_TIMED_PROCEDURE_THREAD}
					${EL_COUNT_CONSUMER_THREAD}*
						${EL_TIMED_PROCEDURE_THREAD}
				${EL_REGULAR_INTERVAL_EVENT_CONSUMER}*
					${EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
					${EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
				${EL_CONSUMER_MAIN_THREAD}* [P]
					${EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
					${EL_COUNT_CONSUMER_MAIN_THREAD}*
					${EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD}
					${EL_ACTION_ARGUMENTS_CONSUMER_MAIN_THREAD} [ARGS -> ${TUPLE} create default_create end]
				${EL_PROCEDURE_CALL_CONSUMER}*
					${EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD}
					${EL_PROCEDURE_CALL_CONSUMER_THREAD}
				${EL_ACTION_ARGUMENTS_CONSUMER}* [ARGS -> ${TUPLE} create default_create end]
					${EL_ACTION_ARGUMENTS_CONSUMER_MAIN_THREAD} [ARGS -> ${TUPLE} create default_create end]
					${EL_ACTION_ARGUMENTS_CONSUMER_THREAD} [ARGS -> ${TUPLE} create default_create end]
						${EL_BATCH_FILE_PROCESSING_THREAD}*
							${EL_LOGGED_BATCH_FILE_PROCESSING_THREAD}*
				${EL_CONSUMER_THREAD}* [P]
					${EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER}*
					${EL_MANY_TO_ONE_CONSUMER_THREAD}* [P]
					${EL_ACTION_ARGUMENTS_CONSUMER_THREAD} [ARGS -> ${TUPLE} create default_create end]
					${EL_COUNT_CONSUMER_THREAD}*
					${EL_PROCEDURE_CALL_CONSUMER_THREAD}
					${EL_DELEGATING_CONSUMER_THREAD} [P, T -> ${EL_MANY_TO_ONE_CONSUMER_THREAD [P]} create make end]
	]"

end