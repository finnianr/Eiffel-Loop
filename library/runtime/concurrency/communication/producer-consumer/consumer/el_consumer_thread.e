note
	description: "Consumes the products placed into product queue by another thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_CONSUMER_THREAD [P]

inherit
	EL_CONSUMER [P]
		undefine
			make_default, name, stop
		end

	EL_CONTINUOUS_ACTION_THREAD
		redefine
			execute, make_default, stop
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_CONTINUOUS_ACTION_THREAD}
			create product_count.make (0)
		end

feature -- Basic operations

	prompt
			--
		do
			product_count.post
		end

	stop
			-- Tell the thread to stop
		do
			if is_consuming then
				Precursor
			else
				Precursor
				prompt
				previous_call_is_thread_signal
-- THREAD SIGNAL
			end
		end

feature {NONE} -- Event handlers

	on_continue
			-- Continue after waiting
		do
		end

	on_stopping
			--
		do
		end

feature {NONE} -- Implementation

	execute
			-- Continuous loop to do action that waits to be prompted
		require else
			waiting_condition_set: product_count.is_set
		do
			Precursor
			if consume_remaining_enabled then
				from until product_queue.is_empty loop
					consume_next_product
				end
			end
		end

	loop_action
		do
			set_waiting
			product_count.wait
			Previous_call_is_blocking_thread
-- THREAD WAITING
			on_continue
			if not is_stopping and then is_product_available then
				set_consuming
				consume_next_product
			end
		end

	product_count: SEMAPHORE

end