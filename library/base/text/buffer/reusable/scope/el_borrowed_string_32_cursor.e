note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary
		[$source STRING_32] buffer can be borrowed from a shared pool. After iterating
		just once the scope finishes and the buffer item is automatically returned to
		the shared `pool' stack.
	]"
	tests: "[
		[$source GENERAL_TEST_SET].test_reusable_strings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 18:31:07 GMT (Monday 6th November 2023)"
	revision: "7"

class
	EL_BORROWED_STRING_32_CURSOR

inherit
	EL_BORROWED_STRING_CURSOR [STRING_32]
		undefine
			bit_count
		redefine
			copied_item, sized_item, substring_item
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	EL_MODULE_REUSEABLE

create
	make

feature -- Access

	copied_item (general: READABLE_STRING_GENERAL): STRING_32
		do
			Result := pooled_item (general.count)
			if attached {ZSTRING} general as zstr then
				zstr.append_to_string_32 (Result)

			else
				Result.append_string_general (general)
			end
		end

	sized_item (n: INTEGER): STRING_32
		do
			Result := pooled_item (n)
			Result.grow (n); Result.set_count (n)
		end

	substring_item (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_32
		do
			Result := pooled_item (end_index - start_index + 1)
			if attached {ZSTRING} general as zstr then
				across Reuseable.string as reuse loop
					if attached reuse.item as l_item then
						l_item.append_substring (zstr, start_index, end_index)
						l_item.append_to_string_32 (Result)
					end
				end

			elseif attached {READABLE_STRING_32} general as str_32 then
				Result.append_substring (str_32, start_index, end_index)
			else
				Result.append_substring_general (general, start_index, end_index)
			end
		end
end