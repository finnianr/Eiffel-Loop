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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-23 12:15:01 GMT (Saturday 23rd April 2022)"
	revision: "5"

class
	EL_BORROWED_STRING_CURSOR [S -> STRING_GENERAL create make end]

inherit
	EL_SCOPE_CURSOR [S]
		redefine
			make
		end

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

	copied_item (general: READABLE_STRING_GENERAL): S
		do
			Result := item
			Result.append (general)
		end

end