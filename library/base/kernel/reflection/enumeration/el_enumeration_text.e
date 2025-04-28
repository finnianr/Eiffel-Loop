note
	description: "Enumeration text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 17:24:30 GMT (Monday 28th April 2025)"
	revision: "4"

deferred class
	EL_ENUMERATION_TEXT [N -> HASHABLE]

inherit
	EL_INTERVAL_ROUTINES_I
		rename
			count as interval_count
		end

	EL_SHARED_IMMUTABLE_8_MANAGER

	EL_MODULE_CONVERT_STRING

	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

feature -- Access

	description (code: N): ZSTRING
		local
			interval: INTEGER_64
		do
			if interval_table.has_key (code) then
				interval := interval_table.found_item
				create Result.make_from_utf_8 (utf_8_text.substring (to_lower (interval) + 1, to_upper (interval)))
				Result.prune_all ('%T')
			else
				create Result.make_empty
			end
		end

feature -- Status query

	values_in_text: BOOLEAN
		-- `True' if enumeration values are found in the `new_table_text' as the first
		-- word of each description.
		do
			Result := False
		end

feature -- Conversion

	as_enum (value: INTEGER): N
		deferred
		end

	as_integer (value: N): INTEGER
		deferred
		end

feature -- Contract Support

	valid_table_keys: BOOLEAN
		do
			Result := count = interval_table.count
		end

feature {NONE} -- Implementation

	new_interval_table (field_list: EL_FIELD_LIST): HASH_TABLE [INTEGER_64, N]
		local
			interval: INTEGER_64; start_index, space_index, value: INTEGER
		do
			if attached new_utf_8_table as table then
				create Result.make (table.count)
				across field_list as list loop
					if attached list.item as field and then table.has_key (field.name) then
						interval := table.found_interval
						start_index := to_lower (interval)
						space_index := utf_8_text.index_of (' ', start_index)
						if values_in_text and then space_index > 0 and then attached Convert_string.integer_32 as integer_32
							and then integer_32.is_substring_convertible (utf_8_text, start_index + 1, space_index - 1)
						then
							value := integer_32.substring_as_type (utf_8_text, start_index + 1, space_index - 1)
							Result.put (interval, as_enum (value))
						else
							Result.put (interval, as_enum (list.cursor_index))
						end
					end
				end
			end
		end

	new_utf_8_table: EL_IMMUTABLE_UTF_8_TABLE
		do
			create Result.make_utf_8 ({EL_TABLE_FORMAT}.Indented_eiffel, utf_8_text)
		end

	set_utf_8_text (table_text: READABLE_STRING_GENERAL)
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			if table_text.is_empty then
				utf_8_text := Empty_text
			else
				utf_8_text := Immutable_8.as_shared (sg.super_readable_general (table_text).to_utf_8)
			end
		end

feature {NONE} -- Deferred

	count: INTEGER
		deferred
		end

	interval_table: EL_SPARSE_ARRAY_TABLE [INTEGER_64, N]
		deferred
		end

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	utf_8_text: IMMUTABLE_STRING_8

feature {NONE} -- Constants

	Empty_text: IMMUTABLE_STRING_8
		once
			create Result.make_empty
		end
end