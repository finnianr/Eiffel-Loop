note
	description: "[
		Export contents of Thunderbird email folder as files containing only contents of HTML body element.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-01 17:50:34 GMT (Friday 1st September 2017)"
	revision: "4"

deferred class
	THUNDERBIRD_FOLDER_EXPORTER [WRITER -> HTML_WRITER create make end]

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		redefine
			call
		end

	EL_HTML_CONSTANTS

	EL_MODULE_TIME
	EL_MODULE_OS
	EL_MODULE_XML
	EL_MODULE_LOG


feature {NONE} -- Initialization

	make (a_output_dir: EL_DIR_PATH)
			--
		do
			make_machine
			output_dir := a_output_dir

			create field_table.make_equal (11)
			create html_lines.make (50)
			create last_header
			create subject_list.make (5)
			create output_file_path
		end

feature -- Basic operations

	export_mails (mails_path: EL_FILE_PATH)
		local
			l_dir: EL_DIRECTORY
		do
			log.enter ("convert_mails")
			create line_source.make_latin (15, mails_path)

			OS.File_system.make_directory (output_dir)

			do_once_with_file_lines (agent find_first_field, line_source)

			-- Remove old files that don't have a match in current `subject_set'
			create l_dir.make (output_dir)
			across related_file_extensions as extension loop
				across l_dir.files_with_extension (extension.item) as file_path loop
					if not subject_list.has (file_path.item.base_sans_extension) then
						lio.put_path_field ("Removing", file_path.item)
						lio.put_new_line
						OS.File_system.remove_file (file_path.item)
					end
				end
			end
			log.exit
		end

feature {NONE} -- State handlers

	find_first_field (line: ZSTRING)
		do
			if line.starts_with (First_field) then
				field_table.wipe_out
				state := agent collect_fields
				collect_fields (line)
			end
		end

	collect_fields (line: ZSTRING)
		local
			pos_colon: INTEGER
		do
			if not line.is_empty then
				if line ~ Html_open then
					set_header_date; set_header_charset; set_header_subject
					on_html_tag (line)

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

	find_end_tag (line: ZSTRING)
			--
		do
			if line.starts_with (end_tag) then
				extend_html (line)
				if not html_lines.is_empty then
					write_html
				end
				state := agent find_first_field

			elseif not line.is_empty then
				extend_html (line)
			end
		end

	on_html_tag (tag_value: ZSTRING)
		deferred
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		do
			indented_line := line.twin
			line.left_adjust
			Precursor (line)
		end

	end_tag: ZSTRING
		deferred
		end

	extend_html (line: ZSTRING)
		do
			html_lines.extend (line)
		end

	file_out_extension: ZSTRING
		do
			Result := related_file_extensions [1]
		end

	related_file_extensions: ARRAY [ZSTRING]
		deferred
		ensure
			at_least_one: Result.count >= 1
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

	set_header_charset
		local
			pos_charset: INTEGER; value: ZSTRING
		do
			value := field_table [Field.content_type]
			pos_charset := value.substring_index (Charset_assignment, 1)
			line_source.set_encoding_from_name (value.substring_end (pos_charset + Charset_assignment.count))
		end

	set_header_subject
		do
			subject_list.extend (field_table [Field.subject])
			last_header.subject := subject_list.last.line
			output_file_path := output_dir + last_header.subject
			output_file_path.add_extension (file_out_extension)
		end

	write_html
		local
			writer: WRITER; source_text: ZSTRING
		do
			log.enter ("write_html")
--			File_system.make_directory (output_file_path.parent)
			if not output_file_path.exists or else last_header.date > output_file_path.modification_date_time then
				lio.put_path_field (file_out_extension, output_file_path)
				lio.put_new_line
				lio.put_string_field ("Character set", line_source.encoding_name)
				lio.put_new_line
				source_text := html_lines.joined_lines
				if source_text.ends_with (Break_tag) then
					source_text.remove_tail (Break_tag.count)
				end
				create writer.make (source_text, output_file_path, last_header.date)
				writer.write
				is_html_updated := True
			else
				is_html_updated := False
			end
			html_lines.wipe_out
			log.exit
		end

feature {NONE} -- Internal attributes

	html_lines: EL_ZSTRING_LIST

	last_header: TUPLE [date: DATE_TIME; subject: ZSTRING]

	line_source: EL_FILE_LINE_SOURCE

	output_dir: EL_DIR_PATH

	output_file_path: EL_FILE_PATH

	subject_list: SUBJECT_LIST

	indented_line: ZSTRING

	is_html_updated: BOOLEAN

	field_table: EL_ZSTRING_HASH_TABLE [ZSTRING]

feature {NONE} -- Constants

	Field: TUPLE [content_type, date, subject: ZSTRING]
		once
			create Result
			Result.content_type := "Content-Type"
			Result.date := "Date"
			Result.subject := "Subject"
		end

	Html_open: ZSTRING
		once
			Result := XML.open_tag ("html")
		end

	Break_tag: ZSTRING
		once
			Result := XML.open_tag ("br")
		end

	Charset_assignment: ZSTRING
		once
			Result := "charset="
		end

	Field_delimiter: ZSTRING
		once
			Result := ": "
		end

	First_field: ZSTRING
		once
			Result := "X-Mozilla-Status:"
		end

end
