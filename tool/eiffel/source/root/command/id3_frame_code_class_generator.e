note
	description: "[
		Tool for `TagLib.ecf' library to generate [$source TL_FRAME_ID_ENUM] from the ID3v2 specification
		documents versions 2.2, 2.3 and 2.4.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 15:21:06 GMT (Tuesday 14th February 2023)"
	revision: "15"

class
	ID3_FRAME_CODE_CLASS_GENERATOR

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_LIO

	EL_MODULE_OS

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

create
	make

feature {EL_APPLICATION} -- Initialization

	make (a_id3v2_include_dir: DIR_PATH)
		do
			make_machine

			id3v2_include_dir := a_id3v2_include_dir
			create field_table.make_equal (100)
			create code_table.make_equal (250)
		end

feature -- Constants

	Description: STRING = "Generate ID3 frame code constant classes for ID3 versions 2.2, 2.3 and 2.4"

feature -- Basic operations

	execute
		local
			parts: EL_SPLIT_ZSTRING_LIST; version: INTEGER
			map_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [STRING, like field_table.item]
			code_class: ID3_CODE_CLASS
		do
			across os.file_list (id3v2_include_dir, "*.txt") as path loop
				if not path.item.base.has_substring ("structure") then
					create parts.make (path.item.base, '.')
					parts.go_i_th (2)
					version := parts.integer_item

					lio.put_labeled_string ("SPECIFICATION", path.item.base)
					lio.put_new_line_x2
					do_once_with_file_lines (agent find_frames_list (?, version), open_lines (path.item, Utf_8))
					lio.put_new_line_x2
					create code_class.make (Current, version, "workarea")
					code_class.serialize
				end
			end
			lio.put_line ("FRAMES TABLE")
			lio.put_new_line
			create map_list.make_from_table (field_table)
			map_list.sort (True)
			from map_list.start until map_list.after loop
				lio.put_labeled_string (map_list.item_key, field_string (map_list.item_value))
				lio.put_new_line
				map_list.forth
			end
		end

feature {NONE} -- Line states

	find_frames_list (line: ZSTRING; version: INTEGER)
		require
			valid_version: 2 <= version and version <= 4
		do
			if line.has_substring (The_following_frames) then
				state := agent find_last_frame (?, version)
			end
		end

	find_last_description_line (a_line: ZSTRING; code: STRING)
		do
			a_line.adjust
			if a_line.is_empty then
				state := agent find_next_code_description
			elseif code_table.has_key (code) then
				code_table.found_item.extend (a_line)
			end
		end

	find_last_frame (a_line: ZSTRING; version: INTEGER)
		local
			line: STRING; start_index, end_index: INTEGER
			code, l_description: STRING
			code_array: ARRAY [STRING]
		do
			line := a_line
			line.left_adjust
			start_index := index_of_capital_letter (line)
			if start_index > 0 then
				end_index := line.index_of (' ', start_index) - 1
				if end_index > 0 then
					code := line.substring (start_index, end_index)
					if not code_table.has (code) then
						code_table.extend (create {EL_ZSTRING_LIST}.make_empty, code)
					end
					l_description := normalized_description (line.substring (end_index + 2, line.count))
					if field_table.has_key (l_description) then
						field_table.found_item [version] := code
					else
						create code_array.make_filled (once "", 2, 4)
						code_array [version] := code
						field_table.extend (code_array, l_description)
					end
					if code.starts_with (WXX) then
						state := agent find_next_code_description
					end
				end
			end
		end

	find_next_code_description (a_line: ZSTRING)
		local
			line: STRING
		do
			a_line.adjust
			line := a_line
			if a_line.ends_with (User_defined_URL_link_frame) then
				state := final

			elseif code_table.has (line) then
				state := agent find_last_description_line (?, line)
			end
		end

feature {NONE} -- Implementation

	field_string (code_array: like field_table.item): STRING
		local
			buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			Result := buffer.empty
			across code_array as code loop
				if not code.item.is_empty then
					if not Result.is_empty then
						Result.append (", ")
					end
					Result.append ("2.")
					Result.append_integer (code.cursor_index + 1)
					Result.append (": %"")
					Result.append (code.item)
					Result.append_character ('"')
				end
			end
		end

	index_of_capital_letter (line: STRING): INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > line.count or else Result > 0 loop
				inspect line [i]
					when 'A' .. 'Z' then
						Result := i
				else
				end
				i := i + 1
			end
		end

	normalized_description (a_description: STRING): STRING
		local
			i: INTEGER
		do
			create Result.make (a_description.count)
			from i := 1 until i > a_description.count loop
				inspect a_description [i]
					when 'A' .. 'Z' then
						Result.extend (a_description.item (i).as_lower)
					when 'a' .. 'z' then
						Result.extend (a_description.item (i))
					when '/', ' ' then
						Result.extend ('_')
				else
				end
				i := i + 1
			end
			Result.replace_substring_all (once "synchronised", once "synchronized")
			Result.replace_substring_all (once "sation", once "zation")
			Result.replace_substring_all (once "unsychronized", once "unsynchronized")
			Result.replace_substring_all (once "original_release time", once "original_release_year")
			Result.replace_substring_all (once "_lead_", once "_")
			Result.replace_substring_all (once "recording_time", once "recording_dates")
--			Result.replace_substring_all (once "", once "")
--			Result.replace_substring_all (once "", once "")

			Result.prune_all_trailing ('_')
		end

feature {ID3_CODE_CLASS} -- Internal attributes

	code_table: EL_HASH_TABLE [EL_ZSTRING_LIST, STRING]

	field_table: EL_HASH_TABLE [ARRAY [STRING], STRING]

	id3v2_include_dir: DIR_PATH

feature {NONE} -- Constants

	The_following_frames: ZSTRING
		once
			Result := "The following frames"
		end

	User_defined_URL_link_frame: ZSTRING
		once
			Result := "User defined URL link frame"
		end

	WXX: STRING = "WXX"

end