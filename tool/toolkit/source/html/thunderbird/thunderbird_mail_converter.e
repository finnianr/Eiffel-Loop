note
	description: "Summary description for {THUNDERBIRD_MAIL_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-12 7:54:10 GMT (Wednesday 12th October 2016)"
	revision: "2"

deferred class
	THUNDERBIRD_MAIL_CONVERTER [WRITER -> HTML_WRITER create make end]

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		redefine
			call
		end

	EL_HTML_CONSTANTS
	EL_SHARED_ZCODEC_FACTORY

	EL_MODULE_TIME
	EL_MODULE_OS
	EL_MODULE_XML
	EL_MODULE_LOG
	EL_MODULE_URL


feature {NONE} -- Initialization

	make (a_output_dir: EL_DIR_PATH)
			--
		require
			a_output_dir_exists: a_output_dir.exists
		do
			make_machine
			output_dir := a_output_dir

			create field_table.make_equal (11)
			create html_lines.make (50)
			create last_header
			create subject_order.make (5)
			subject_order.compare_objects
			create line_reader.make (new_iso_8859_codec (15))
			create file_base_name_set.make_equal (10)
			create output_file_path
		end

feature -- Basic operations

	convert_mails (mails_path: EL_FILE_PATH)
		local
			file_lines: EL_FILE_LINE_SOURCE
		do
			log.enter ("convert_mails")
			create file_lines.make_latin (15, mails_path)

			do_once_with_file_lines (agent find_first_field, file_lines)

			-- Remove old files that don't have a match in current set
			across OS.file_list (output_dir, file_out_wildcard) as file_path loop
				if not file_base_name_set.has (file_path.item.base) then

					lio.put_path_field ("Removing", file_path.item)
					lio.put_new_line
					remove_file (file_path.item)
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
						field_table.put (line.substring (pos_colon + 2, line.count), line.substring (1, pos_colon - 1))
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

	decode_subject (s: ZSTRING): ZSTRING
			-- Decode something like "Halo =?ISO-8859-15?Q?Tageb=FCcher-=BE=BD?="
		require
			all_encodings_are_latin_15: s.has_substring ("=?ISO") implies s.has_substring (Latin_15_declaration)
		local
			parts: EL_ZSTRING_LIST; url_encoded_line: ZSTRING
		do
			if s.has_substring (Latin_15_declaration) then
				create parts.make_with_separator (s, '?', False)
				url_encoded_line := parts.i_th (4).translated (Translation.original, Translation.new)
				line_reader.set_line (URL.unescape_string (url_encoded_line))
				Result := line_reader.line
			else
				Result := s
			end
		end

	Translation: TUPLE [original, new: ZSTRING]
		once
			create Result
			Result.original := " _="
			Result.new := "++%%"
		end

	end_tag: ZSTRING
		deferred
		end

	extend_html (line: ZSTRING)
		do
			html_lines.extend (line)
		end

	file_out_extension: ZSTRING
		deferred
		end

	file_out_wildcard: ZSTRING
		do
			Result := "*."
			Result.append (file_out_extension)
		end

	last_latin_set_index: INTEGER
		do
			Result := last_header.charset.split ('-').last.to_integer
		end

	remove_file (file_path: EL_FILE_PATH)
		do
			OS.File_system.remove_file (file_path)
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
			last_header.charset := value.substring (pos_charset + Charset_assignment.count, value.count)
			check
				is_latin_15: last_latin_set_index = 15
			end
		end

	set_header_subject
		local
			subject, index, value: ZSTRING
			pos_dot: INTEGER
		do
			value := field_table [Field.subject]
			subject := decode_subject (value)
			pos_dot := subject.index_of ('.', 1)
			if pos_dot > 0 then
				index := subject.substring (1,  pos_dot - 1)
				if index.is_integer then
					subject.remove_head (pos_dot)
					subject_order.put (subject, index.to_integer)
				end
			end
			last_header.subject := subject
			output_file_path := output_dir + subject
			output_file_path.add_extension (file_out_extension)
			file_base_name_set.put (output_file_path.base)
		end

	write_html
		require
			is_latin_15: last_latin_set_index = 15
		local
			writer: WRITER; source_text: ZSTRING
		do
			log.enter ("write_html")
--			File_system.make_directory (output_file_path.parent)
			if not output_file_path.exists or else last_header.date > output_file_path.modification_date_time then
				lio.put_path_field (file_out_extension, output_file_path)
				lio.put_new_line
				lio.put_string_field ("Character set", last_header.charset)
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

	file_base_name_set: EL_HASH_SET [ZSTRING]

	html_lines: EL_ZSTRING_LIST

	last_header: TUPLE [date: DATE_TIME; subject, charset: ZSTRING]

	line_reader: EL_ENCODED_LINE_READER [FILE]

	output_dir: EL_DIR_PATH

	output_file_path: EL_FILE_PATH

	subject_order: HASH_TABLE [ZSTRING, INTEGER]

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

	Latin_15_declaration: ZSTRING
		once
			Result := "?ISO-8859-15?"
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
