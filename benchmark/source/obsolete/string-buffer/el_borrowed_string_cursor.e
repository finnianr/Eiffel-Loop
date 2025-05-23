note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary string buffer
		conforming to ${STRING_GENERAL} can be borrowed from a shared pool. After iterating
		just once the scope finishes and the buffer item is automatically returned to the shared `pool'
		stack.
	]"
	notes: "[
		See `${GENERAL_TEST_SET}.test_reusable_strings' for an example
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 14:12:29 GMT (Sunday 30th March 2025)"
	revision: "18"

deferred class
	EL_BORROWED_STRING_CURSOR [S -> STRING_GENERAL create make end]

inherit
	ITERATION_CURSOR [S]

	EL_STRING_BIT_COUNTABLE [S]

	EL_STRING_HANDLER

	EL_READABLE_STRING_GENERAL_ROUTINES_I
		export
			{NONE} all
		end

	EL_STRING_GENERAL_ROUTINES_I

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
		end

feature -- Access

	best_item (preferred_capacity: INTEGER): S
		do
			if attached internal_item as str then
				Result := str
			else
				Result := pool.borrowed_item (preferred_capacity)
				pool_index := pool.last_index
				internal_item := Result
			end
		end

	copied_item_general (general: READABLE_STRING_GENERAL): S
		deferred
		end

	copied_item (str: READABLE_STRING_GENERAL): S
		deferred
		end

	same_item (general: READABLE_STRING_GENERAL): S
		-- `general' is type of general conforms to `S'
		-- or else a copy of `general'
		do
			if attached {S} general as same then
				Result := same
			else
				Result := copied_item (general)
			end
		end

	sized_item (n: INTEGER): S
		deferred
		ensure
			size_is_n: Result.count = n
		end

	substring_item (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): S
		deferred
		end

	substring_item_general (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): S
		deferred
		end

feature -- Access

	item: S
		do
			Result := best_item (0)
		end

feature -- Status query

	after: BOOLEAN

feature -- Status change

	start
		do
			after := False
		end

feature -- Cursor movement

	forth
		local
			void_item: detachable S
		do
			after := True
			if attached internal_item as str then
				pool.free (pool_index)
				internal_item := void_item
			end
		end

feature {NONE} -- Internal attributes

	internal_item: detachable S

	pool_index: INTEGER

	pool: EL_STRING_POOL [S]

end