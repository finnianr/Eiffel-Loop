note
	description: "[
		Compact string table with items encoded as shared UTF-8 created from table manifest formatted as:
		
			key_1:
				line 1..
				line 2..
			key_2:
				line 1..
				line 2..
			..
			
		The keys must be lowercase Eiffel identifiers.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-13 8:23:31 GMT (Sunday 13th August 2023)"
	revision: "3"

class
	EL_IMMUTABLE_UTF_8_TABLE

inherit
	EL_IMMUTABLE_STRING_8_TABLE
		rename
			make as make_table,
			found_item as found_utf_8_item
		redefine
			new_cursor
		end

	EL_MODULE_REUSEABLE

	EL_SHARED_STRING_8_CURSOR

create
	make, make_empty

feature {NONE} -- Initialization

	make (table_manifest: READABLE_STRING_GENERAL)
		-- make from manifest formatted as:
		-- 	key_1:
		--			line 1..
		--			line 2..
		-- 	key_2:
		--			line 1..
		--			line 2..
		-- 	..
		local
			c: EL_UTF_8_CONVERTER
		do
			if attached {READABLE_STRING_8} table_manifest as str_8
				and then cursor_8 (str_8).all_ascii
			then
				make_by_indented (str_8)
			else
				make_by_indented (c.utf_32_string_to_string_8 (table_manifest))
			end
		end

feature -- Access

	found_item: ZSTRING
		do
			Result := new_item (found_interval)
		end

	new_cursor: EL_IMMUTABLE_UTF_8_TABLE_CURSOR
		do
			create Result.make (Current)
			Result.start
		end

feature {EL_IMMUTABLE_UTF_8_TABLE_CURSOR} -- Implementation

	new_item (interval: INTEGER_64): ZSTRING
		local
			start_index, end_index, interval_count: INTEGER_32; ir: EL_INTERVAL_ROUTINES
			split_on_tab_new_line: EL_SPLIT_IMMUTABLE_UTF_8_LIST
		do
			start_index := ir.to_lower (interval); end_index := ir.to_upper (interval)
			interval_count := end_index - start_index + 1

			if interval_count = 0 then
				create Result.make_empty

			elseif attached new_substring (start_index + 1, end_index) as substring then
				if substring.is_empty then
					create Result.make_empty

				elseif substring.has ('%N') then
					create split_on_tab_new_line.make_by_string (substring, New_line_tab)
					create Result.make (split_on_tab_new_line.character_count + split_on_tab_new_line.count - 1)
					if attached split_on_tab_new_line as list then
						from list.start until list.after loop
							if list.index > 1 then
								Result.append_character ('%N')
							end
							Result.append_utf_8 (list.item)
							list.forth
						end
					end

				else
					create Result.make_from_utf_8 (substring)
				end
			end
		end

feature {NONE} -- Constants

	New_line_tab: STRING = "%N%T"
end