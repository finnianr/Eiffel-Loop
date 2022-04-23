note
	description: "[
		Queue to notify an event listener from main application thread. A shared instance is accessible
		via [$source EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-23 13:31:29 GMT (Saturday 23rd April 2022)"
	revision: "10"

deferred class
	EL_MAIN_THREAD_EVENT_REQUEST_QUEUE

inherit
	EL_THREAD_ACCESS [ARRAYED_LIST [EL_EVENT_LISTENER]]

feature -- Element change

	on_event (index: INTEGER)
			--
		local
			event_listener: EL_EVENT_LISTENER
		do
			if attached restricted_access (Listener_pool) as pool then
				event_listener := pool [index]
				pool [index] := Default_event_listener

				end_restriction
			end

			event_listener.notify
		end

	put (event_listener: EL_EVENT_LISTENER)
			-- Queue request to notify listener from main (GUI) thread
			-- but we can't assume OS will return them in the same order
		do
			if attached restricted_access (Listener_pool) as pool then
				pool.start
				pool.search (Default_event_listener)
				if pool.exhausted then
					pool.extend (event_listener)
				else
					pool.replace (event_listener)
				end
				generate_event (pool.index)
				end_restriction
			end
		end

	put_action (action: PROCEDURE)
			-- Queue request to call action from main (GUI) thread
			-- but we can't assume OS will return them in the same order
		do
			put (create {EL_AGENT_EVENT_LISTENER}.make (action))
		end

	put_event_indexes (a_event_indexes: LINKED_QUEUE [INTEGER])
			--
		do
			restrict_access (Listener_pool)
				from until a_event_indexes.is_empty loop
					generate_event (a_event_indexes.item)
					a_event_indexes.remove
				end
			end_restriction
		end

feature {NONE} -- Implementation

	new_event_listener_pool: EL_ARRAYED_LIST [EL_EVENT_LISTENER]
		do
			create Result.make_filled (20, agent the_default)
		end

	generate_event (index: INTEGER)
			--
		deferred
		end

	the_default (i: INTEGER): EL_EVENT_LISTENER
		do
			Result := Default_event_listener
		end

feature {NONE} -- Constants

	Default_event_listener: EL_DEFAULT_EVENT_LISTENER
			--
		once ("PROCESS")
			create Result
		end

	Listener_pool: EL_MUTEX_REFERENCE [ARRAYED_LIST [EL_EVENT_LISTENER]]
			-- Can't assume OS will return them in the same order
		once ("PROCESS")
			create Result.make (new_event_listener_pool)
		end

end