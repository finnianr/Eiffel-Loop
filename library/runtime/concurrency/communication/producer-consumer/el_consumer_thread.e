note
	description: "Consumes the products of a product queue fed by another thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 6:34:53 GMT (Sunday 3rd July 2016)"
	revision: "1"

deferred class
	EL_CONSUMER_THREAD [P]

inherit
	EL_CONSUMER [P]
		undefine
			make_default, is_equal, copy, stop, name
		end

	EL_CONTINUOUS_ACTION_THREAD
		rename
			loop_action as consume_product
		redefine
			execute, stop
		end

feature {NONE} -- Initialization

	make
			--
		do
			make_default
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
		local
			waiting_for_prompt: BOOLEAN
		do
			waiting_for_prompt := is_waiting
			set_state (State_stopping)
			if waiting_for_prompt then
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
			set_active
			from until is_stopping loop
				set_waiting
				product_count.wait
				Previous_call_is_blocking_thread
-- THREAD WAITING
				on_continue
				if not is_stopping and is_product_available then
					set_consuming
					consume_next_product
				end
			end
			on_stopping
			set_stopped
		end

	product_count: SEMAPHORE

end


