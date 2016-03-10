note
	description: "[
		Proxy object to (asynchronously) call procedures of BASE_TYPE from an another thread
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_THREAD_PROXY [BASE_TYPE, OPEN_ARGS -> TUPLE create default_create end]

create
	make

feature {NONE} -- Initialization

	make (a_target: like target)
			--
		do
			create call_queue.make
			make_call_consumer
			call_queue.attach_consumer (call_consumer)
			call_consumer.launch
			target := a_target
		end

feature {NONE} -- Initialization

	make_call_consumer
			--
		do
			create call_consumer.make
		end

feature -- Basic operations

	stop
			--
		do
			call_consumer.stop
		end

feature {NONE} -- Implementation

	queue_call, call (procedure: PROCEDURE [BASE_TYPE, OPEN_ARGS])
			-- Asynchronously call procedure
		do
			call_queue.put (procedure)
		end

	queue_call_with_args, call_with_args (procedure: PROCEDURE [BASE_TYPE, OPEN_ARGS]; args: OPEN_ARGS)
			-- Asynchronously call procedure
		do
			procedure.set_operands (args)
			call_queue.put (procedure)
		end

	call_queue: EL_PROCEDURE_CALL_QUEUE [BASE_TYPE, OPEN_ARGS]

	call_consumer: EL_PROCEDURE_CALL_CONSUMER_THREAD [BASE_TYPE, OPEN_ARGS]

	target: BASE_TYPE

end
