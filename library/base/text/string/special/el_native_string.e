note
	description: "${NATIVE_STRING} with support for ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-13 7:45:59 GMT (Sunday 13th April 2025)"
	revision: "10"

class
	EL_NATIVE_STRING

inherit
	NATIVE_STRING
		rename
			string as to_string_32
		redefine
			set_substring
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_SHARED_STRING_32_BUFFER_POOL

create
	make, make_empty, make_from_pointer, make_from_raw_string

feature -- Access

	to_string: ZSTRING
		do
			if attached String_32_pool.borrowed_item as borrowed then
				if {PLATFORM}.is_windows then
					Result := borrowed.copied_utf_16_0 (managed_data)
				else
					Result := borrowed.copied_utf_8_0 (managed_data)
				end
				borrowed.return
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
			if conforms_to_zstring (a_string) then
				count := end_index - start_index + 1
				if attached String_32_pool.sufficient_item (count) as borrowed then
					Precursor (borrowed.copied_substring_general (a_string, start_index, end_index), 1, count)
					borrowed.return
				end
			else
				Precursor (a_string, start_index, end_index)
			end
		ensure then
			string_set: to_string_32.same_characters_general (a_string, start_index, end_index, 1)
		end
end