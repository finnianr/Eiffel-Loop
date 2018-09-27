note
	description: "[
		Export contents of Thunderbird email folder as files containing only contents of HTML body element.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-27 17:43:53 GMT (Thursday 27th September 2018)"
	revision: "7"

deferred class
	EL_THUNDERBIRD_FOLDER_EXPORTER [WRITER -> EL_HTML_WRITER create make end]

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		redefine
			call
		end

	EL_HTML_CONSTANTS

	EL_MODULE_FILE_SYSTEM
	EL_MODULE_TIME
	EL_MODULE_XML
	EL_MODULE_LIO
	EL_MODULE_DIRECTORY

	EL_SHARED_ONCE_STRINGS


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
			create line_source.make_latin (15, mails_path)

			File_system.make_directory (output_dir)

			do_once_with_file_lines (agent find_first_field, line_source)

			-- Remove old files that don't have a match in current `subject_set'
			create l_dir.make (output_dir)
			across related_file_extensions as extension loop
				across l_dir.files_with_extension (extension.item) as file_path loop
					if not subject_list.has (file_path.item.base_sans_extension) then
						lio.put_path_field ("Removing", file_path.item)
						lio.put_new_line
						File_system.remove_file (file_path.item)
					end
				end
			end
		end

feature {NONE} -- State handlers

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
			if line.starts_with (end_tag_name) then
				extend_html (line)
				if not html_lines.is_empty then
					close_tags (<< "img", "meta" >>)
					write_html
				end
				state := agent find_first_field

			elseif not line.is_empty then
				extend_html (line)
			end
		end

	find_first_field (line: ZSTRING)
		do
			if line.starts_with (First_field) then
				field_table.wipe_out
				state := agent collect_fields
				collect_fields (line)
			end
		end

	on_html_tag (tag_value: ZSTRING)
		deferred
		end

feature {NONE} -- Implementation

	as_xml (html: ZSTRING): ZSTRING
		local
			part: EL_SPLIT_ZSTRING_LIST; buffer: ZSTRING
		do
			create part.make (html, Html_break_tag)
			buffer := empty_once_string
			from part.start until part.after loop
				if part.index > 1 then
					buffer.append (Break_tag)
				end
				substitute_html_entities (part.item, buffer)
				part.forth
			end
			Result := buffer.twin
		end

	call (line: ZSTRING)
		do
			indented_line := line.twin
			line.left_adjust
			Precursor (line)
		end

	close_tags (names: ARRAY [STRING])
		local
			tag: ZSTRING; line: like html_lines; pos_tag, from_index, pos_bracket: INTEGER
			found: BOOLEAN
		do
			across names as name loop
				create tag.make (name.item.count + 1)
				tag.append_character ('<')
				tag.append_string_general (name.item)
				line := html_lines
				from_index := 1
				from line.start until line.after loop
					if found then
						pos_bracket := line.item.index_of ('>', from_index)
						if pos_bracket > 0 then
							line.item.insert_character ('/', pos_bracket)
							from_index := pos_bracket + 2
							found := false
						else
							from_index := 1
							line.forth
						end
					else
						if from_index < line.item.count then
							pos_tag := line.item.substring_index (tag, from_index)
						else
							pos_tag := 0
						end
						if pos_tag > 0 then
							found := True
							from_index := pos_tag
						else
							from_index := 1
							line.forth
						end
					end
				end
			end
		end

	end_tag_name: ZSTRING
		deferred
		end

	extend_html (line: ZSTRING)
		do
			html_lines.extend (as_xml (line))
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
			output_file_path := output_dir + last_header.subject
			output_file_path.add_extension (file_out_extension)
		end

	substitute_html_entities (html, buffer: ZSTRING)
		local
			parts: EL_SPLIT_ZSTRING_LIST; semi_colon_pos: INTEGER
			part, entity_name: ZSTRING
		do
			create parts.make (html, Ampersand)
			if parts.count = 1 then
				buffer.append (html)
			else
				parts.start
				buffer.append (parts.item.twin)
				parts.forth
				from until parts.after loop
					part := parts.item
					semi_colon_pos := part.index_of (';', 1)
					if semi_colon_pos > 0 then
						entity_name := part.substring (1, semi_colon_pos - 1)
						Entity_numbers.search (entity_name)
						if Entity_numbers.found then
							buffer.append (XML.entity (Entity_numbers.found_item))
							buffer.append (part.substring_end (semi_colon_pos + 1))
						else
							buffer.append (part)
						end
					else
						buffer.append (part)
					end
					parts.forth
				end
			end
		end

	write_html
		local
			writer: WRITER; source_text: ZSTRING
		do
			File_system.make_directory (output_file_path.parent)
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
		end

feature {NONE} -- Internal attributes

	field_table: EL_ZSTRING_HASH_TABLE [ZSTRING]

	html_lines: EL_ZSTRING_LIST

	indented_line: ZSTRING

	is_html_updated: BOOLEAN

	last_header: TUPLE [date: DATE_TIME; subject: ZSTRING]

	line_source: EL_FILE_LINE_SOURCE

	output_dir: EL_DIR_PATH

	output_file_path: EL_FILE_PATH

	subject_list: EL_SUBJECT_LIST

feature {NONE} -- Constants

	Ampersand: ZSTRING
		once
			Result := "&"
		end

	Break_tag: ZSTRING
		-- <br/>
		once
			Result := XML.empty_tag ("br")
		end

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

	Html_break_tag: ZSTRING
		-- <br>
		once
			Result := XML.open_tag ("br")
		end

	Html_open: ZSTRING
		once
			Result := XML.open_tag ("html")
		end

end
