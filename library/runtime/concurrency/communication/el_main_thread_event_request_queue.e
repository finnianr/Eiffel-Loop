note
	description: "[
		Queue to notify an event listener from main application thread
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_MAIN_THREAD_EVENT_REQUEST_QUEUE

inherit
	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE
		export
			{NONE} all
		end

feature -- Element change

	put_action (action: PROCEDURE [ANY, TUPLE])
			-- Queue request to call action from main (GUI) thread
			-- but we can't assume OS will return them in the same order
		do
			put (create {EL_EVENT_LISTENER_ACTION}.make (action))
		end

	put_event_indexes (a_event_indexes: LINKED_QUEUE [INTEGER])
			--
		do
			Listener_pool.lock
--			synchronized
				from until a_event_indexes.is_empty loop
					generate_event (a_event_indexes.item)
					a_event_indexes.remove
				end
--			end
			Listener_pool.unlock
		end

	put (event_listener: EL_EVENT_LISTENER)
			-- Queue request to notify listener from main (GUI) thread
			-- but we can't assume OS will return them in the same order
		local
			l_listener_pool: ARRAYED_LIST [EL_EVENT_LISTENER]
		do
			Listener_pool.lock
			l_listener_pool := Listener_pool.item
--			synchronized
				l_listener_pool.start
				l_listener_pool.search (Default_event_listener)
				if l_listener_pool.exhausted then
					l_listener_pool.extend (event_listener)
				else
					l_listener_pool.replace (event_listener)
				end
				generate_event (l_listener_pool.index)
--			end
			Listener_pool.unlock
		end

	on_event (index: INTEGER)
			--
		local
			l_listener_pool: ARRAYED_LIST [EL_EVENT_LISTENER]
			event_listener: EL_EVENT_LISTENER
		do
			Listener_pool.lock
			l_listener_pool := Listener_pool.item
--			synchronized
				event_listener := l_listener_pool [index]
				l_listener_pool [index] := Default_event_listener
--			end
			Listener_pool.unlock
			event_listener.notify
		end

feature {NONE} -- Implementation

	generate_event (index: INTEGER)
			--
		deferred
		end

	register_main_thread_implementation
			--
		do
			set_main_thread_event_request_queue (Current)
		end

	create_event_listener_pool: ARRAYED_LIST [EL_EVENT_LISTENER]
		do
			create Result.make (20)
			from Result.start until Result.full loop
				Result.extend (Default_event_listener)
				Result.forth
			end
		end

feature {NONE} -- Constants

	Listener_pool: EL_SYNCHRONIZED_REF [ARRAYED_LIST [EL_EVENT_LISTENER]]
			-- Can't assume OS will return them in the same order
		once ("PROCESS")
			create Result.make (create_event_listener_pool)
		end

	Default_event_listener: EL_DEFAULT_EVENT_LISTENER
			--
		once ("PROCESS")
			create Result
		end

end
