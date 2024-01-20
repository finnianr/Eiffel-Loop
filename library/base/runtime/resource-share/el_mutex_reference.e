note
	description: "[
		Restricts access to objects that require thread synchronization.
		For debugging it is recommended to use ${EL_LOGGED_MUTEX_REFERENCE} to detect deadlock.
		Any time a thread is forced to wait for a lock it is reported to the thread's log.
	]"
	notes: "[
		23 April 2022
		
		As an experiment tried to inherit class ${EL_ITERABLE_SCOPE} as way to define locked scope
		but this was unsuccessful. The test class ${HORSE_RACE_APP} just froze.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "11"

class
	EL_MUTEX_REFERENCE [G]

inherit
	MUTEX
		rename
			make as make_mutex
		end

create
	make, make_from

feature {NONE} -- Initialization

	make (an_item: like item)
			--
		do
			make_mutex
			actual_item := an_item
		end

	make_from (new_item: FUNCTION [like item])
		do
			new_item.apply
			make (new_item.last_result)
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