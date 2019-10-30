note
	description: "[
		Queue to notify an event listener from main application thread
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-30 14:23:45 GMT (Wednesday   30th   October   2019)"
	revision: "5"

deferred class
	EL_MAIN_THREAD_EVENT_REQUEST_QUEUE

inherit
	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE
		export
			{NONE} all
		end

	EL_THREAD_ACCESS

feature -- Element change

	put_action (action: PROCEDURE)
			-- Queue request to call action from main (GUI) thread
			-- but we can't assume OS will return them in the same order
		do
			put (create {EL_EVENT_LISTENER_ACTION}.make (action))
		end

	put_event_indexes (a_event_indexes: LINKED_QUEUE [INTEGER])
			--
		do
			restrict_access (Listener_pool)
				from until a_event_indexes.is_empty loop
					generate_event (a_event_indexes.item)
					a_event_indexes.remove
				end
			end_restriction (Listener_pool)
		end

	put (event_listener: EL_EVENT_LISTENER)
			-- Queue request to notify listener from main (GUI) thread
			-- but we can't assume OS will return them in the same order
		local
			pool: like Listener_pool.item
		do
			restrict_access (Listener_pool)
				pool := Listener_pool.item
				pool.start
				pool.search (Default_event_listener)
				if pool.exhausted then
					pool.extend (event_listener)
				else
					pool.replace (event_listener)
				end
				generate_event (pool.index)
			end_restriction (Listener_pool)
		end

	on_event (index: INTEGER)
			--
		local
			event_listener: EL_EVENT_LISTENER
			pool: like Listener_pool.item
		do
			restrict_access (Listener_pool)
				pool := Listener_pool.item
				event_listener := pool [index]
				pool [index] := Default_event_listener
			end_restriction (Listener_pool)

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

	create_event_listener_pool: EL_ARRAYED_LIST [EL_EVENT_LISTENER]
		do
			create Result.make_filled (20, agent the_default)
		end

	the_default (i: INTEGER): EL_EVENT_LISTENER
		do
			Result := Default_event_listener
		end

feature {NONE} -- Constants

	Listener_pool: EL_MUTEX_REFERENCE [ARRAYED_LIST [EL_EVENT_LISTENER]]
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
