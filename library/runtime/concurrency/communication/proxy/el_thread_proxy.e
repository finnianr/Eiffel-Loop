note
	description: "[
		Proxy object to (asynchronously) call procedures of target type `T' from an another thread
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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