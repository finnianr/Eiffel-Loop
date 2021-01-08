note
	description: "[
		Read folder of Thunderbird HTML email content and collects email headers in `field_table'
		HTML content is collected in line list `html_lines' and then event handler `on_email_end' is
		called, before processing the next email.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 18:04:53 GMT (Friday 8th January 2021)"
	revision: "10"

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

	EL_THUNDERBIRD_CONSTANTS

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	make (a_config: like config)
			--
		do
			make_default
			config := a_config
		end

	make_default
		do
			Precursor
			create output_dir
			create line_source.make_default
			create field_table.make_equal (11)
			create subject_list.make (5)
			create html_lines.make (50)
			last_header := [create {DATE_TIME}.make_now, Empty_string]
		end

feature -- Access

	output_dir: EL_DIR_PATH

feature -- Basic operations

	read_mails (mails_path: EL_FILE_PATH)
		local
			export_steps: EL_PATH_STEPS
		do
			-- Read headers as Latin-1, but this is changed for HTML section according to
			-- charset field
			create line_source.make (Latin_1, mails_path)
			subject_list.wipe_out

			export_steps := config.export_steps (mails_path)
			output_dir := config.export_dir.joined_dir_steps (export_steps)

			File_system.make_directory (output_dir)

			do_once_with_file_lines (agent find_first_header, line_source)
		end

feature {NONE} -- State handlers

	collect_headers (line: ZSTRING)
		local
			pos_colon: INTEGER
		do
			if not line.is_empty then
				if line.begins_with (First_doc_tag) then
					set_header_date; set_header_charset; set_header_subject
					on_first_tag (line)

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

	find_first_header (line: ZSTRING)
		do
			if line.starts_with (Field.first) then
				field_table.wipe_out
				html_lines.wipe_out

				state := agent collect_headers
				collect_headers (line)
			end
		end

	find_last_tag (line: ZSTRING)
		local
			last_line: ZSTRING
		do
			if line.begins_with (Last_doc_tag) then
				on_last_tag (line)
			elseif line_included (line) then
				-- Correct lines like:
				-- <h2 class="first">Introduction<br/>
				-- </h2>
				if across Heading_levels as level some line.begins_with (header_tag (level.item).close) end
					and then not html_lines.is_empty
				then
					line.left_adjust
					last_line := html_lines.last
					if last_line.ends_with (Tag.break.open) then
						last_line.replace_substring (line, last_line.count - Tag.break.open.count + 1 , last_line.count)
					else
						last_line.append (line)
					end
				else
					html_lines.extend (line)
				end
			end
		end

	on_first_tag (line: ZSTRING)
		do
			html_lines.extend (line)
			state := agent find_last_tag
		end

	on_last_tag (line: ZSTRING)
		do
			html_lines.extend (line)
			on_email_collected
			state := agent find_first_header
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

feature {NONE} -- Implementation

	intervals (line, search_string: ZSTRING): like Occurrence_intervals
		do
			Result := Occurrence_intervals
			Result.fill (line, search_string)
		end

	is_empty_tag_line (line: ZSTRING): BOOLEAN
		-- True if line conforms to string pattern:
		-- 	[white space][open tag][white space][corresponding closing tag]
		-- For example: "    <p> </p>"
		-- (Useful in redefinition of `line_included')

		local
			bracket_intervals: like intervals
			right_bracket_pos: INTEGER; s: EL_ZSTRING_ROUTINES
		do
			bracket_intervals := intervals (line, s.character_string ('<'))
			if bracket_intervals.count = 2
				and then line.is_substring_whitespace (1, bracket_intervals.first_lower - 1)
				and then line.same_characters (Tag_close_start, 1, 2, bracket_intervals.last_lower)
				and then line.ends_with_character ('>')
			then
				right_bracket_pos := line.index_of ('>', bracket_intervals.first_lower + 1)
				if right_bracket_pos > 0
					and then right_bracket_pos < bracket_intervals.last_lower
					and then line.is_substring_whitespace (right_bracket_pos + 1, bracket_intervals.last_lower - 1)
				then
					-- True if left and right tag names are the same
					Result := line.same_characters (
						line, bracket_intervals.first_lower + 1, right_bracket_pos - 1, bracket_intervals.first_lower + 1
					)
				end
			end
		end

	line_included (line: ZSTRING): BOOLEAN
		-- when true `line' is added to `html_lines'
		do
			Result := True
		end

	on_email_collected
		-- Called after each email headers and content is collected and ready for processing
		deferred
		end

feature {NONE} -- Internal attributes

	config: EL_THUNDERBIRD_ACCOUNT_READER

	field_table: EL_ZSTRING_HASH_TABLE [ZSTRING]

	html_lines: EL_ZSTRING_LIST

	last_header: TUPLE [date: DATE_TIME; subject: ZSTRING]

	line_source: EL_PLAIN_TEXT_LINE_SOURCE

	subject_list: EL_SUBJECT_LIST

feature {NONE} -- Constants

	Charset_assignment: ZSTRING
		once
			Result := "charset="
		end

	Field: TUPLE [first, content_type, date, subject: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "X-Mozilla-Status:, Content-Type, Date, Subject")
		end

	Field_delimiter: ZSTRING
		once
			Result := ": "
		end

	First_doc_tag: ZSTRING
		once
			Result := Tag.html.open
		end

	Last_doc_tag: ZSTRING
		once
			Result := Tag.html.close
		end

	Occurrence_intervals: EL_OCCURRENCE_INTERVALS [ZSTRING]
		once
			create Result.make_empty
		end

end