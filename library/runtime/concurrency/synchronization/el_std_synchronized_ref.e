note
	description: "[
		Guards objects that require thread synchronization.
		EL_STD_SYNCHRONIZED_REF is the same as EL_SYNCHRONIZED_REF except it does not write anything to
		the logging framework. It is used within the logging framework to avoid circular calls.
		
		For normal use it is recommended that EL_SYNCHRONIZED_REF be used because it helps to detect deadlock.
		Any time a thread is forced to wait for a lock it is reported to the thread's log.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_STD_SYNCHRONIZED_REF [G]

inherit
	THREAD_CONTROL

create
	make

feature {NONE} -- Initialization

	make (an_item: like item)
			--
		do
			create monitor.make
			owner_id := Ownerless_id
			actual_item := an_item
		end

feature -- Basic

	lock
			--
		do
			monitor.lock
			owner_id := current_thread_id
		ensure
			monitor_aquired: is_monitor_aquired
		end

	unlock
			--
		require
			monitor_aquired: is_monitor_aquired
		do
			owner_id := Ownerless_id
			monitor.unlock
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

feature -- Status query

	is_item_set: BOOLEAN
			--
		do
			Result := actual_item /= Void
		end

	is_monitor_aquired: BOOLEAN
			-- Does the current thread own the monitor
		do
			Result := owner_id = current_thread_id
		end

	is_monitor_relinquished: BOOLEAN
			-- Does the current thread not own the monitor

			-- Useful later when porting to Linux/Unix which does not support recursive mutexes
			-- (Use to strengthen pre/post conditions on lock and unlock)
		do
			Result := owner_id = Ownerless_id
		end

feature {NONE} -- Implementation

	actual_item: G

	owner_id: POINTER

	monitor: MUTEX

feature {NONE} -- Constants

	Ownerless_id: POINTER
			-- Returns 0xFFFFFFFF
			-- Guessing that it is unlikely that any thread will ever have this id
		once
			Result := Result + -1
		end

invariant
	monitor_not_void: monitor /= Void

	current_thread_id_never_equal_to_ownerless_id: current_thread_id /= Ownerless_id

end




