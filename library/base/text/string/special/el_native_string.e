note
	description: "[$source NATIVE_STRING] with support for [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 17:55:23 GMT (Monday 1st January 2024)"
	revision: "2"

class
	EL_NATIVE_STRING

inherit
	NATIVE_STRING
		rename
			string as to_string_32
		redefine
			set_substring
		end

	EL_SHARED_CLASS_ID; EL_SHARED_STRING_32_BUFFER_SCOPES

create
	make, make_empty, make_from_pointer, make_from_raw_string

feature -- Access

	to_string: ZSTRING
		do
			across String_32_scope as scope loop
				if {PLATFORM}.is_windows then
					Result := scope.copied_utf_16_0_item (managed_data)
				else
					Result := scope.copied_utf_8_0_item (managed_data)
				end
			end
		end

feature -- Element change

	set_empty_capacity (a_length: INTEGER)
		do
			make_empty (a_length)
		end

	set_substring (a_string: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		local
			count: INTEGER
		do
			inspect Class_id.character_bytes (a_string)
				when 'X' then
					across String_32_scope as scope loop
						count := end_index - start_index + 1
						Precursor (scope.substring_item (a_string, start_index, end_index), 1, count)
					end
			else
				Precursor (a_string, start_index, end_index)
			end
		end
end