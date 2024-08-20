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
	date: "2024-04-08 11:03:29 GMT (Monday 8th April 2024)"
	revision: "15"

class
	EL_BORROWED_STRING_CURSOR [S -> STRING_GENERAL create make end]

inherit
	ITERATION_CURSOR [S]

	EL_STRING_BIT_COUNTABLE [S]

	STRING_HANDLER

	EL_READABLE_STRING_GENERAL_ROUTINES_IMP
		export
			{NONE} all
		end

	EL_STRING_GENERAL_ROUTINES

create
	make

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

	copied_item (general: READABLE_STRING_GENERAL): S
		do
			Result := best_item (general.count)
			Result.append (general)
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
		do
			create Result.make (n)
		ensure
			size_is_n: Result.count = n
		end

	substring_item (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): S
		do
			Result := best_item (end_index - start_index + 1)
			Result.append_substring (general, start_index, end_index)
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