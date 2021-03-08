note
	description: "[
		Proxy object to (asynchronously) call procedures of target type `T' from an another thread
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 13:06:42 GMT (Saturday 6th March 2021)"
	revision: "4"

class
	EL_THREAD_PROXY [T]

create
	make

feature {NONE} -- Initialization

	make (a_target: like target)
			--
		do
			create call_queue.make (10)
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

	queue_call, call (procedure: PROCEDURE)
			-- Asynchronously call procedure
		do
			call_queue.put (procedure)
		end

	call_queue: EL_PROCEDURE_CALL_QUEUE

	call_consumer: EL_PROCEDURE_CALL_CONSUMER_THREAD

	target: T

end