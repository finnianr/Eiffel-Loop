note
	description: "[
		Restricts access to objects that require thread synchronization.
		For debugging it is recommended to use EL_LOGGED_SYNCHRONIZED_REF to detect deadlock.
		Any time a thread is forced to wait for a lock it is reported to the thread's log.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-15 12:47:03 GMT (Friday 15th May 2015)"
	revision: "2"

class
	EL_MUTEX_REFERENCE [G]

inherit
	MUTEX
		rename
			make as make_mutex
		end

create
	make

feature {NONE} -- Initialization

	make (an_item: like item)
			--
		do
			make_mutex
			actual_item := an_item
		end

feature -- Element change

	set_item (an_item: like item)
			--
		do
			actual_item := an_item
		end

feature -- Access

	item: like actual_item
			--
		require
			item_set: is_item_set
			monitor_aquired: is_monitor_aquired
		do
			Result := actual_item
		end

feature -- Basic operations

	call (action: PROCEDURE [ANY, TUPLE [a_item: like item]])
		do
			lock
			action.call ([item])
			unlock
		end

feature -- Status query

	is_item_set: BOOLEAN
			--
		do
			Result := actual_item /= Void
		end

	is_monitor_aquired: BOOLEAN
			-- Does the current thread own the monitor
		do
			Result := owner = current_thread_id
		end

	is_monitor_relinquished: BOOLEAN
			-- Does the current thread not own the monitor

			-- Useful later when porting to Linux/Unix which does not support recursive mutexes
			-- (Use to strengthen pre/post conditions on lock and unlock)
		do
			Result := owner = default_pointer
		end

feature {NONE} -- Implementation

	actual_item: G

end




