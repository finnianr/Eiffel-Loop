note
	description: "[
		For a structure that already defines `new_cursor', use this class to make an alternative way to iterate the structure
		using a different item type.
	]"
	notes: "[
		**Examples**

			${JSON_ZNAME_VALUE_LIST}.pairs
			${EL_PLAIN_TEXT_FILE}.lines

		Both of these classes already have a definition for `new_cursor'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 14:48:55 GMT (Saturday 22nd March 2025)"
	revision: "1"

class
	EL_ITERATION_CURSOR_FACTORY [G, TARGET, TARGETED_CURSOR -> EL_TARGETED_ITERATION_CURSOR [G, TARGET] create make end]

inherit
	ITERABLE [G]

create
	make

feature {NONE} -- Initialization

	make (a_target: like target)
		do
			target := a_target
		end

feature -- Access

	new_cursor: TARGETED_CURSOR
		do
			create Result.make (target)
		end

feature {NONE} -- Internal attributes

	target: TARGET
end
