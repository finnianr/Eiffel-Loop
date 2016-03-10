note
	description: "Summary description for {EXTRACT_TAG_INFO_SYSTEM_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_EXTRACT_ID3_TAGS_COMMAND

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [EL_EXTRACT_ID3_TAG_INFO_IMPL]
		rename
			make as make_path
		redefine
			Line_processing_enabled, do_with_line, on_finish
		end

create
	make

feature {NONE} -- Initialization

	make (a_path: like path)
			--
		do
			make_path (a_path)
			create fields.make (11)
		end

feature -- Access

	fields: HASH_TABLE [STRING, STRING]

feature {NONE} -- Implementation

	do_with_line (line: STRING)
			--
		local
			pos_field_delimiter: INTEGER
			field_name, field_value: STRING
			last_character: CHARACTER
		do
			pos_field_delimiter := line.substring_index (Field_delimiter, 1)
			if pos_field_delimiter > 0 then
				field_name := line.substring (1, pos_field_delimiter - 1)
				field_value := line.substring (pos_field_delimiter + Field_delimiter.count, line.count)
				fields [field_name] := field_value
				if T_or_U_set.has (field_value.item (field_value.count)) then
					last_character_is_T_or_U_count := last_character_is_T_or_U_count + 1
				end
			end
		end

	on_finish
		local
			last_character: CHARACTER
		do
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

	last_character_is_T_or_U_count: INTEGER

feature {NONE} -- Constants

	T_or_U_set: ARRAY [CHARACTER]
		once
			Result := << 'T', 'U' >>
		end

	Line_processing_enabled: BOOLEAN = true

	Field_delimiter: STRING = " - "

end
