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
	date: "2022-12-12 9:37:28 GMT (Monday 12th December 2022)"
	revision: "3"

class
	EL_BORROWED_STRING_32_CURSOR

inherit
	EL_BORROWED_STRING_CURSOR [STRING_32]
		redefine
			copied_item, substring_item
		end

	EL_MODULE_REUSEABLE

create
	make

feature -- Access

	copied_item (general: READABLE_STRING_GENERAL): STRING_32
		do
			Result := item
			if attached {ZSTRING} general as zstr then
				zstr.append_to_string_32 (Result)

			elseif attached {READABLE_STRING_32} general as str_32 then
				Result.append (str_32)
			else
				Result.append_string_general (general)
			end
		end

	substring_item (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_32
		do
			Result := item
			if attached {ZSTRING} general as zstr then
				across Reuseable.string as reuse loop
					reuse.item.append_substring (zstr, start_index, end_index)
					reuse.item.append_to_string_32 (Result)
				end

			elseif attached {READABLE_STRING_32} general as str_32 then
				Result.append_substring (str_32, start_index, end_index)
			else
				Result.append_substring_general (general, start_index, end_index)
			end
		end
end