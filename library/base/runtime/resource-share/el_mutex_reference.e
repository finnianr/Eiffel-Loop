note
	description: "[
		Restricts access to objects that require thread synchronization.
		For debugging it is recommended to use [$source EL_LOGGED_MUTEX_REFERENCE] to detect deadlock.
		Any time a thread is forced to wait for a lock it is reported to the thread's log.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-06 11:32:36 GMT (Tuesday 6th April 2021)"
	revision: "7"

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

	locked: like actual_item
		-- convenience function to define a locked scope as follows:

		-- 	if attached my_object.locked as l_my_object then
		-- 		..
		-- 		my_object.unlock
		-- 	end
		do
			lock
			Result := actual_item
		end

feature -- Basic operations

	call (action: PROCEDURE [G])
		do
			lock
			action (item)
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


