note
	description: "Consumes the products of a product queue fed by another thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-13 17:46:54 GMT (Wednesday 13th March 2013)"
	revision: "2"

deferred class
	EL_CONSUMER_THREAD [P]

inherit
	EL_CONSUMER [P]
		undefine
			is_equal, copy, stop, default_create
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
			default_create
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

feature {NONE} -- Implementation

	execute
			-- Continuous loop to do action that waits to be prompted
		require else
			waiting_condition_set: product_count.is_set
		do
			set_active
			from until is_stopping loop
				log.put_line ("waiting")
				set_waiting
				product_count.wait
				Previous_call_is_blocking_thread
-- THREAD WAITING
				log.put_line ("received product")
				if not is_stopping and is_product_available then
					set_consuming
					consume_next_product
				end
			end
			on_stopping
			set_stopped
		end

	on_stopping
			--
		do
		end

	product_count: SEMAPHORE

end



