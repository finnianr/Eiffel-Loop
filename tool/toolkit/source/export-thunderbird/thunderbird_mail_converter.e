note
	description: "Summary description for {THUNDERBIRD_MAIL_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "5"

deferred class
	THUNDERBIRD_MAIL_CONVERTER [WRITER -> HTML_WRITER create make end]

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		redefine
			call
		end

	EL_MODULE_TIME
	EL_MODULE_STRING
	EL_MODULE_FILE_SYSTEM
	EL_MODULE_XML
	EL_MODULE_LOG
	EL_MODULE_URL

	EL_HTML_CONSTANTS
	EL_SHARED_CODEC_FACTORY

feature {NONE} -- Initialization

	make (a_output_dir: EL_DIR_PATH)
			--
		require
			a_output_dir_exists: a_output_dir.exists
		do
			make_machine
			output_dir := a_output_dir

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
			create file_lines.make (mails_path)
			file_lines.set_encoding (file_lines.Encoding_iso_8859, 15)

			do_once_with_file_lines (agent find_date, file_lines)

			-- Remove old files that don't have a match in current set
			across File_system.file_list (output_dir, file_out_wildcard) as file_path loop
				if not file_base_name_set.has (file_path.item.base) then

					log_or_io.put_path_field ("Removing", file_path.item)
					log_or_io.put_new_line
					remove_file (file_path.item)
				end
			end
		end

feature {NONE} -- State handlers

	find_charset (line: ASTRING)
		local
			pos_charset: INTEGER
		do
			if line.starts_with (Content_type_field) then
				line.remove_head (Content_type_field.count)
				pos_charset := line.substring_index (Charset_assignment, 1)
				last_header.charset := line.substring (pos_charset + Charset_assignment.count, line.count)
				state := agent find_start
				check
					is_latin_15: last_latin_set_index = 15
				end
			end
		end

	find_date (line: ASTRING)
		local
			date_steps: EL_STRING_LIST [STRING]
			l_date: DATE_TIME
		do
			if line.starts_with (Date_field) then
				line.remove_head (Date_field.count)
				create date_steps.make_with_words (line.string.as_upper)
				create l_date.make_from_string (date_steps.subchain (2, 5).joined_words, "dd mmm yyyy hh:[0]mi:[0]ss")
				last_header.date := l_date
				state := agent find_subject
			end
		end

	find_end_tag (line: ASTRING)
			--
		do
			if line.starts_with (end_tag) then
				extend_html (line)
				if not html_lines.is_empty then
					write_html
				end
				state := agent find_date

			elseif not line.is_empty then
				extend_html (line)
			end
		end

	find_start (line: ASTRING)
		deferred
		end

	find_subject (line: ASTRING)
		local
			subject, index: ASTRING
			pos_dot: INTEGER
		do
			if line.starts_with (Subject_field) then
				line.remove_head (Subject_field.count)
				subject := decode_subject (line)
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

				state := agent find_charset
			end
		end

feature {NONE} -- Implementation

	call (line: ASTRING)
		do
			indented_line := line.twin
			line.left_adjust
			Precursor (line)
		end

	decode_subject (s: ASTRING): ASTRING
			-- Decode something like "Halo =?ISO-8859-15?Q?Tageb=FCcher-=BE=BD?="
		require
			all_encodings_are_latin_15: s.has_substring ("=?ISO") implies s.has_substring (Latin_15_declaration)
		local
			parts: EL_ASTRING_LIST; url_encoded_line: ASTRING
		do
			if s.has_substring (Latin_15_declaration) then
				create parts.make_with_separator (s, '?', False)
				url_encoded_line := parts.i_th (4).translated (" _=", "++%%")
				line_reader.set_line (URL.unescape_string (url_encoded_line))
				Result := line_reader.line
			else
				Result := s
			end
		end

	end_tag: STRING
		deferred
		end

	extend_html (line: ASTRING)
		do
			html_lines.extend (line)
		end

	file_out_extension: ASTRING
		deferred
		end

	file_out_wildcard: ASTRING
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
			File_system.remove_file (file_path)
		end

	write_html
		require
			is_latin_15: last_latin_set_index = 15
		local
			writer: WRITER; source_text: ASTRING
		do
			log.enter ("write_html")
--			File_system.make_directory (output_file_path.parent)
			if not output_file_path.exists or else last_header.date > output_file_path.modification_time then
				log_or_io.put_path_field (file_out_extension, output_file_path)
				log_or_io.put_new_line
				log_or_io.put_string_field ("Character set", last_header.charset)
				log_or_io.put_new_line
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

	file_base_name_set: EL_HASH_SET [ASTRING]

	html_lines: EL_ASTRING_LIST

	last_header: TUPLE [date: DATE_TIME; subject, charset: ASTRING]

	line_reader: EL_ENCODED_LINE_READER [FILE]

	output_dir: EL_DIR_PATH

	output_file_path: EL_FILE_PATH

	subject_order: HASH_TABLE [ASTRING, INTEGER]

	indented_line: ASTRING

	is_html_updated: BOOLEAN

feature {NONE} -- Constants

	Break_tag: ASTRING
		once
			Result := XML.open_tag ("br")
		end

	Charset_assignment: STRING = "charset="

	Content_type_field: STRING = "Content-Type: "

	Date_field: STRING = "Date: "

	Latin_15_declaration: ASTRING
		once
			Result := "?ISO-8859-15?"
		end

	Subject_field: STRING = "Subject: "

end
