note
	description: "List of Thunderbird email content and headers of type ${TB_EMAIL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 7:49:04 GMT (Monday 14th April 2025)"
	revision: "8"

class
	TB_EMAIL_LIST

inherit
	EL_ARRAYED_LIST [TB_EMAIL]
		rename
			make as make_list
		export
			{NONE} wipe_out, remove, remove_head, prune
		end

	EL_PLAIN_TEXT_FILE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			copy, is_equal
		redefine
			call
		end

	EL_MODULE_TUPLE

create
	make, make_empty

feature {NONE} -- Initialization

	make (file_path: FILE_PATH)
		require
			path_exists: file_path.exists
		do
			source_path := file_path
			make_machine
			create content_buffer.make_empty
			create field_list.make_empty
			if file_path.exists then
				make_list (20)
				create subject_set.make_equal (20)
				do_with_lines (agent find_from_date, file_path)
				find_from_date ("From - Sun Apr 03 12:25:48 2016") -- Force last email to be appended
			else
				create subject_set.make_equal (0)
				make_empty
			end
		end

feature -- Access

	source_path: FILE_PATH

feature -- Status query

	has_subject (line: ZSTRING): BOOLEAN
		do
			Result := subject_set.has (line)
		end

feature {NONE} -- Implementation

	call (line: STRING)
		do
			line.prune_all_trailing ('%R')
			state (line)
		end

	find_empty_line (line: STRING)
		local
			start_index: INTEGER; sg: EL_STRING_GENERAL_ROUTINES
			name, value: STRING
		do
			if line.is_empty then
				state := agent find_from_date

			elseif line.count > 1 and then line [1] = ' ' then
				field_list.last_value.append (line)
			else
				start_index := 1
				name := sg.super_8 (line).substring_to_from (':', $start_index)
				value := line.substring (start_index + 1, line.count)
				field_list.extend (name, value)
			end
		end

	find_from_date (line: STRING)
		local
			email: TB_EMAIL
		do
			if line.starts_with (Field.from_) and then line.occurrences (':') = 2
				and then line.occurrences (' ') = 6
			then
				if field_list.count > 0 then
					create email.make
					if attached field_list as list then
						from list.start until list.after loop
							email.set_field (list.item_key, list.item_value)
							list.forth
						end
					end
					email.content.append_encoded (content_buffer, email.content_encoding)
					extend (email); subject_set.put (email.subject_decoded)
					field_list.wipe_out
					content_buffer.wipe_out
				end
				state := agent find_empty_line
			else
				if content_buffer.count > 0 then
					content_buffer.append_character ('%N')
				end
				content_buffer.append (line)
			end
		end

feature {NONE} -- Internal attributes

	content_buffer: STRING

	field_list: EL_ARRAYED_MAP_LIST [STRING, STRING]

	subject_set: EL_HASH_SET [ZSTRING]

feature {NONE} -- Constants

	Field: TUPLE [content_transfer_encoding, from_: STRING]
		once
			create Result
			Tuple.fill (Result, "Content-Transfer-Encoding, From -")
		end

end