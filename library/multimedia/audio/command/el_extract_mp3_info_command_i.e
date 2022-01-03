note
	description: "Extract mp3 info command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "8"

deferred class
	EL_EXTRACT_MP3_INFO_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		undefine
			do_command, make_default, new_command_parts
		redefine
			path
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			getter_function_table, Transient_fields
		redefine
			make_default, do_with_lines
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			create fields.make_equal (11)
			Precursor
		end

feature -- Access

	path: FILE_PATH

	fields: EL_ZSTRING_HASH_TABLE [ZSTRING]

feature {NONE} -- Implementation

	do_with_lines (lines: like adjusted_lines)
			--
		local
			last_character_is_T_or_U_count, pos_field_delimiter: INTEGER
			T_or_U_set: ARRAY [CHARACTER_32]; last_character: CHARACTER_32
			field_name, field_value: ZSTRING
		do
			T_or_U_set := << 'T', 'U' >>
			from lines.start until lines.after loop
				pos_field_delimiter := lines.item.substring_index (Field_delimiter, 1)
				if pos_field_delimiter > 0 then
					field_name := lines.item.substring (1, pos_field_delimiter - 1)
					field_value := lines.item.substring_end (pos_field_delimiter + Field_delimiter.count)
					fields [field_name] := field_value
					if T_or_U_set.has (field_value.item (field_value.count)) then
						last_character_is_T_or_U_count := last_character_is_T_or_U_count + 1
					end
				end
				lines.forth
			end
			if last_character_is_T_or_U_count > (fields.count // 4).max (3) then
				from fields.start until fields.after loop
					last_character := fields.item_for_iteration.item (fields.item_for_iteration.count)
					if (fields.key_for_iteration.as_lower ~ "genre" and last_character = 'U' )
						or else last_character = 'T'
					then
						fields.item_for_iteration.remove_tail (1)
					end
					fields.forth
				end
			end
		end

feature {NONE} -- Constants

	Field_delimiter: ZSTRING
		once
			Result := " - "
		end

end