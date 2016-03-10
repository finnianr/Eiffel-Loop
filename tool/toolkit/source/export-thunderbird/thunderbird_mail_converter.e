note
	description: "Summary description for {THUNDERBIRD_MAIL_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:28 GMT (Monday 22nd July 2013)"
	revision: "3"

deferred class
	THUNDERBIRD_MAIL_CONVERTER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
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

feature {NONE} -- Initialization

	make (a_output_dir: EL_DIR_PATH)
			--
		require
			a_output_dir_exists: a_output_dir.exists
		do
			output_dir := a_output_dir

			create html.make (50)
			create last_header

			pre_tag := XML.open_tag ("pre")
			closed_pre_tag := XML.closed_tag ("pre")
		end

feature -- Basic operations

	convert_mails (mails_path: EL_FILE_PATH)
		local
			file_lines: EL_FILE_LINE_SOURCE
		do
			create file_lines.make (mails_path)
			file_lines.set_encoding (file_lines.Encoding_iso_8859, 15)

			do_with_lines (agent find_date, file_lines)
		end

feature {NONE} -- State handlers

	find_date (line: EL_ASTRING)
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

	find_subject (line: EL_ASTRING)
		do
			if line.starts_with (Subject_field) then
				line.remove_head (Subject_field.count)
				last_header.subject := decode_subject (line)
				state := agent find_charset
			end
		end

	find_charset (line: EL_ASTRING)
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

	find_start (line: EL_ASTRING)
		deferred
		end

	find_end_tag (line, end_tag: EL_ASTRING)
			--
		do
			if trim_line.starts_with (end_tag) then
				html.extend (line)
				write_html
				state := agent find_date

			elseif trim_line.starts_with (pre_tag) then
				state := agent find_pre_tag_end (?, end_tag)
				find_pre_tag_end (line, end_tag)

			elseif trim_line.starts_with ("<p> </p>") then
				-- Ignore empty paragraph

			elseif trim_line.starts_with ("</p>") then
				html.extend (line)

			else
				if trim_line.starts_with ("<") then
					html.extend (line)
				else
					html.last.append_character (' ')
					html.last.append (trim_line)
				end
			end
		end

	find_pre_tag_end (line, end_tag: EL_ASTRING)
			--
		do
			if line.ends_with (closed_pre_tag) then
				html.last.append (line)
				state := agent find_end_tag (?, end_tag)
			else
				html.extend (line)
			end
		end

feature {NONE} -- Implementation

	call (line: EL_ASTRING)
		do
			trim_line := line.string
			trim_line.left_adjust
			Precursor (line)
		end

	last_latin_set_index: INTEGER
		do
			Result := last_header.charset.split ('-').last.to_integer
		end

	decode_subject (s: EL_ASTRING): EL_ASTRING
			-- Decode something like "Halo =?ISO-8859-15?Q?Tageb=FCcher-=BE=BD?="
		local
			encoded_line, url_encoded_line: EL_ASTRING
			pos_encoded: INTEGER
		do
			pos_encoded := s.substring_index ("=?ISO", 1)
			if pos_encoded > 0 then
				Result := s.substring (1, pos_encoded - 1)
				encoded_line := s.substring (pos_encoded, s.count).split ('?').i_th (4)
				url_encoded_line := encoded_line.translated (" _=", "++%%")
				Result.append (URL.unescape_string (url_encoded_line))
			else
				Result := s
			end
		end

	write_html
		require
			is_latin_15: last_latin_set_index = 15
		local
			file_out: PLAIN_TEXT_FILE; file_path: EL_FILE_PATH
		do
			log.enter ("write_html")
			file_path := output_dir + last_header.subject
			file_path.add_extension (file_out_extension)

			if not file_path.exists or else last_header.date > file_path.modification_time then
				log_or_io.put_path_field (file_out_extension, file_path)
				log_or_io.put_new_line
				log_or_io.put_string_field ("Character set", last_header.charset)
				log_or_io.put_new_line

				remove_trailing_line_breaks

				create file_out.make_open_write (file_path.unicode)
				html.do_all (agent write_line (?, file_out))
				file_out.close
				file_out.set_date (Time.unix_date_time (last_header.date))
			end

			html.wipe_out
			log.exit
		end

	write_line (line: EL_ASTRING; file_out: PLAIN_TEXT_FILE)
		deferred
		end

	remove_trailing_line_breaks
			-- remove any line break occurring immediately before tags: p, pre, h?
		local
			line_item, previous_line: EL_ASTRING
			removed: BOOLEAN
		do
			create line_item.make_empty
			create previous_line.make_empty
			from html.start until html.after loop
				removed := False
				line_item := html.item.twin
				line_item.left_adjust
				if line_item.starts_with ("</")
					and then line_item [line_item.count] = '>'
					and then Closing_text_tags.has (line_item.substring (3, line_item.count - 1))
					and then previous_line.ends_with (break_tag)
				then
					previous_line.remove_tail (break_tag.count)
					previous_line.right_adjust
					previous_line.append (line_item)
					html.remove
					removed := True
				else
					previous_line := html.item
				end
				if not removed then
					html.forth
				end
			end
		end

	file_out_extension: EL_ASTRING
		deferred
		end

	trim_line: EL_ASTRING

	last_header: TUPLE [date: DATE_TIME; subject, charset: EL_ASTRING]

	output_dir: EL_DIR_PATH

	closed_pre_tag: EL_ASTRING

	pre_tag: EL_ASTRING

	break_tag: EL_ASTRING

	html: ARRAYED_LIST [EL_ASTRING]

feature {NONE} -- Constants

	Closing_text_tags: ARRAYED_LIST [EL_ASTRING]
		once
			from create Result.make (7) until Result.full loop
				Result.extend (create {EL_ASTRING}.make (2))
				if Result.count = 1 then
					Result.last.append_character ('p')
				else
					Result.last.append_character ('h')
					Result.last.append_integer (Result.count - 1)
				end
			end
			Result.compare_objects
		end

	Date_field: STRING = "Date: "

	Subject_field: STRING = "Subject: "

	Content_type_field: STRING = "Content-Type: "

	Charset_assignment: STRING = "charset="

end
