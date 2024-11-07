note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary
		${ZSTRING} buffer can be borrowed from a shared pool. After iterating
		just once the scope finishes and the buffer item is automatically returned to
		the shared `pool' stack.
	]"
	tests: "[
		${GENERAL_TEST_SET}.test_reusable_strings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 9:53:25 GMT (Tuesday 5th November 2024)"
	revision: "12"

class
	EL_BORROWED_ZSTRING_CURSOR

inherit
	EL_BORROWED_STRING_CURSOR [ZSTRING]
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

create
	make

feature -- Access

	copied_item (str: EL_READABLE_ZSTRING): ZSTRING
		do
			Result := best_item (str.count)
			Result.append (str)
		end

	copied_item_general (general: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := best_item (general.count)
			Result.append_string_general (general)
		end

	sized_item (n: INTEGER): ZSTRING
		do
			Result := best_item (n)
			Result.grow (n)
			Result.set_count (n)
		end

	substring_item (str: EL_READABLE_ZSTRING; start_index, end_index: INTEGER): ZSTRING
		do
			Result := best_item (end_index - start_index + 1)
			Result.append_substring (str, start_index, end_index)
		end

	substring_item_general (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): ZSTRING
		do
			Result := best_item (end_index - start_index + 1)
			Result.append_substring_general (general, start_index, end_index)
		end
end