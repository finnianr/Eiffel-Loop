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
	date: "2023-02-27 10:21:43 GMT (Monday 27th February 2023)"
	revision: "9"

class
	EL_BORROWED_STRING_CURSOR [S -> STRING_GENERAL create make end]

inherit
	EL_SCOPE_CURSOR [S]
		redefine
			make
		end

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_scope: like scope)
		do
			Precursor (a_scope)
		ensure then
			empty_item: item.is_empty
		end

feature -- Access

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

	copied_item (general: READABLE_STRING_GENERAL): S
		do
			Result := item
			Result.append (general)
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
end