note
	description: "Enumeration text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-27 16:00:28 GMT (Sunday 27th April 2025)"
	revision: "1"

deferred class
	EL_ENUMERATION_TEXT [N -> HASHABLE]

inherit
	EL_INTERVAL_ROUTINES_I
		rename
			count as interval_count
		end

	EL_SHARED_IMMUTABLE_8_MANAGER

	EL_MODULE_CONVERT_STRING

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

feature {NONE} -- Implementation

	new_interval_table (field_name_list: ARRAYED_LIST [READABLE_STRING_8]): HASH_TABLE [INTEGER_64, N]
		local
			interval: INTEGER_64; start_index, space_index: INTEGER
		do
			if attached new_utf_8_table as table then
				create Result.make (table.count)
				across field_name_list as list loop
					if attached list.item as name and then table.has_key (name) then
						interval := table.found_interval
						start_index := to_lower (interval)
						space_index := utf_8_text.index_of (' ', start_index)
						if space_index > 0 and then attached converter as conv
							and then conv.is_substring_convertible (utf_8_text, start_index + 1, space_index - 1)
						then
							Result.put (interval, code_value (conv, start_index + 1, space_index - 1))
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
				create utf_8_text.make_empty
			else
				utf_8_text := Immutable_8.as_shared (sg.super_readable_general (table_text).to_utf_8)
			end
		end

feature {NONE} -- Deferred

	code_value (a_converter: like converter; start_index, end_index: INTEGER): N
		deferred
		end

	converter: EL_READABLE_STRING_GENERAL_TO_NUMERIC [NUMERIC]
		deferred
		end

	interval_table: EL_SPARSE_ARRAY_TABLE [INTEGER_64, N]
		deferred
		end

feature {NONE} -- Internal attributes

	utf_8_text: IMMUTABLE_STRING_8

end