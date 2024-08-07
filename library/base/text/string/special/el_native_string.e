note
	description: "${NATIVE_STRING} with support for ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-08 14:18:17 GMT (Monday 8th April 2024)"
	revision: "6"

class
	EL_NATIVE_STRING

inherit
	NATIVE_STRING
		rename
			string as to_string_32
		redefine
			set_substring
		end

	EL_STRING_GENERAL_ROUTINES

	EL_SHARED_STRING_32_BUFFER_SCOPES

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

	trimmed_data: MANAGED_POINTER
		-- trimmed copy of `managed_data' with NULL terminator if present
		local
			l_count: INTEGER
		do
			l_count := bytes_count
			if managed_data.count >= bytes_count + unit_size then
				inspect unit_size
					when 2 then
						if managed_data.read_natural_16_be (l_count) = 0 then
							l_count := l_count + 2 -- allow {NATURAL_16}.zero terminator
						end
				else
					if managed_data.read_natural_8 (l_count) = 0 then
						l_count := l_count + 1 -- allow {NATURAL_8}.zero terminator
					end
				end
			end
			create Result.make_from_pointer (managed_data.item, l_count)
		end

	new_data (str: READABLE_STRING_GENERAL): MANAGED_POINTER
		do
			set_string (str)
			Result := trimmed_data
		end

	new_substring_data (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): MANAGED_POINTER
		do
			set_substring (str, start_index, end_index)
			Result := trimmed_data
		end

feature -- Element change

	set_empty_capacity (a_length: INTEGER)
		-- Allocate for `a_length' code units and the null character.
		do
			make_empty (a_length)
		end

	set_substring (a_string: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		local
			count: INTEGER
		do
			if is_zstring (a_string) then
				across String_32_scope as scope loop
					count := end_index - start_index + 1
					Precursor (scope.substring_item (a_string, start_index, end_index), 1, count)
				end
			else
				Precursor (a_string, start_index, end_index)
			end
		ensure then
			string_set: to_string_32.same_characters_general (a_string, start_index, end_index, 1)
		end
end