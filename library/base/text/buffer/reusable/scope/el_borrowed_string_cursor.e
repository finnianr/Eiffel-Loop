note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary string buffer
		conforming to [$source STRING_GENERAL] can be borrowed from a shared pool. After iterating
		just once the scope finishes and the buffer item is automatically returned to the shared `pool'
		stack.
	]"
	notes: "[
		See `[$source GENERAL_TEST_SET].test_reusable_strings' for an example
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 18:24:25 GMT (Monday 6th November 2023)"
	revision: "11"

class
	EL_BORROWED_STRING_CURSOR [S -> STRING_GENERAL create make end]

inherit
	ITERATION_CURSOR [S]

	EL_STRING_BIT_COUNTABLE [S]

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
		end

feature -- Access

	copied_item (general: READABLE_STRING_GENERAL): S
		do
			Result := pooled_item (general.count)
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
			Result := item
			Result.append_substring (general, start_index, end_index)
		end

feature -- Access

	item: S
		do
			Result := pooled_item (0)
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
		do
			after := True
			if attached internal_item as str then
				pool.return (str)
			end
		end

feature {NONE} -- Implementation

	pooled_item (preferred_size: INTEGER): S
		do
			if attached internal_item as str then
				Result := str
			else
				Result := pool.borrowed_item (preferred_size)
				internal_item := Result
			end
		end

feature {NONE} -- Internal attributes

	internal_item: detachable S

	pool: EL_STRING_POOL [S]

end