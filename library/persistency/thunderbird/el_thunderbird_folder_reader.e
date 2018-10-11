note
	description: "[
		Reads folder of Thunderbird HTML email content and collects email headers in `field_table'
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_THUNDERBIRD_FOLDER_READER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_default
		redefine
			make_default
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_XML

	EL_STRING_CONSTANTS

feature {NONE} -- Initialization

	make (a_output_dir: EL_DIR_PATH; a_character_set: EL_ENCODING)
			--
		do
			make_default
			output_dir := a_output_dir; character_set := a_character_set
		end

	make_default
		do
			Precursor
			create line_source.make_default
			create field_table.make_equal (11)
			create subject_list.make (5)
			create html_lines.make (50)
			last_header := [create {DATE_TIME}.make_now, Empty_string]
		end

feature -- Basic operations

	read_mails (mails_path: EL_FILE_PATH)
		do
			create line_source.make_encoded (character_set, mails_path)

			File_system.make_directory (output_dir)

			do_once_with_file_lines (agent find_first_field, line_source)
		end

feature {NONE} -- State handlers

	collect_fields (line: ZSTRING)
		local
			pos_colon: INTEGER
		do
			if not line.is_empty then
				if line ~ Html_tag.open then
					set_header_date; set_header_charset; set_header_subject
					find_html_close (line)
					state := agent find_html_close

				elseif line.z_code (1) = 32 then
					field_table.found_item.append (line)
				else
					pos_colon := line.substring_index (Field_delimiter, 1)
					if pos_colon > 0 then
						field_table.put (line.substring_end (pos_colon + 2), line.substring (1, pos_colon - 1))
					end
				end
			end
		end

	find_first_field (line: ZSTRING)
		do
			if line.starts_with (First_field) then
				field_table.wipe_out
				html_lines.wipe_out

				state := agent collect_fields
				collect_fields (line)
			end
		end

	find_html_close (line: ZSTRING)
		do
			html_lines.extend (line)
			if line.starts_with (Html_tag.close) then
				on_email_end
				state := agent find_first_field
			end
		end

feature {NONE} -- Implementation

	set_header_charset
		local
			pos_charset: INTEGER; value: ZSTRING
		do
			value := field_table [Field.content_type]
			pos_charset := value.substring_index (Charset_assignment, 1)
			line_source.set_encoding_from_name (value.substring_end (pos_charset + Charset_assignment.count))
		end

	set_header_date
		local
			date_steps: EL_ZSTRING_LIST
			l_date: DATE_TIME; value: ZSTRING
		do
			value := field_table [Field.date]
			create date_steps.make_with_words (value.as_upper)
			create l_date.make_from_string (date_steps.subchain (2, 5).joined_words, "dd mmm yyyy hh:[0]mi:[0]ss")
			last_header.date := l_date
		end

	set_header_subject
		do
			subject_list.extend (field_table [Field.subject])
			last_header.subject := subject_list.last
		end

feature {NONE} -- Deferred

	on_email_end
		deferred
		end

feature {NONE} -- Internal attributes

	character_set: EL_ENCODING

	field_table: EL_ZSTRING_HASH_TABLE [ZSTRING]

	last_header: TUPLE [date: DATE_TIME; subject: ZSTRING]

	line_source: EL_FILE_LINE_SOURCE

	output_dir: EL_DIR_PATH

	html_lines: EL_ZSTRING_LIST

	subject_list: EL_SUBJECT_LIST

feature {NONE} -- Constants

	Charset_assignment: ZSTRING
		once
			Result := "charset="
		end

	Field: TUPLE [content_type, date, subject: ZSTRING]
		once
			create Result
			Result.content_type := "Content-Type"
			Result.date := "Date"
			Result.subject := "Subject"
		end

	Field_delimiter: ZSTRING
		once
			Result := ": "
		end

	First_field: ZSTRING
		once
			Result := "X-Mozilla-Status:"
		end

	Html_tag: TUPLE [open, close: ZSTRING]
		once
			Result := XML.tag ("html")
		end

end
