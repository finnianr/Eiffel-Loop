note
	description: "Thunderbird folder to xhtml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-14 11:27:27 GMT (Friday 14th January 2022)"
	revision: "13"

deferred class
	EL_THUNDERBIRD_XHTML_EXPORTER

inherit
	EL_THUNDERBIRD_FOLDER_READER
		rename
			read_mails as export_mails
		redefine
			make_default, export_mails, set_header_subject
		end

	EL_XML_ESCAPE_ROUTINES
		rename
			entity as xml_entity
		end

	EL_HTML_CONSTANTS

	EL_MODULE_BUFFER
	EL_MODULE_TIME
	EL_MODULE_LIO
	EL_MODULE_DIRECTORY


feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create output_file_path
		end

feature -- Basic operations

	export_mails (mails_path: FILE_PATH)
		do
			Precursor (mails_path)
			remove_old_files
		end

feature {NONE} -- Implementation

	edit (html_doc: ZSTRING)
		local
			s: EL_ZSTRING_ROUTINES
		do
			-- Remove surplus breaks
			across Text_tags as l_tag loop
				html_doc.edit (l_tag.item.open, l_tag.item.close, agent edit_text_tags)
			end
			-- Remove empty
			across List_tags as l_tag loop
				html_doc.edit (l_tag.item.open, l_tag.item.close, agent edit_list_tag)
			end

	 		-- remove trailing breaks between elements <img.. /> and <p>
			html_doc.edit (Tag_start.image, Paragraph.open, agent remove_trailing_breaks)

			-- Change <br> to <br/>
			across Unclosed_tags as l_tag loop
				html_doc.edit (l_tag.item, s.character_string ('>'), agent close_empty_tag)
			end
			html_doc.edit (s.character_string ('&'), s.character_string (';'), agent substitute_html_entities)
			html_doc.edit (Tag_start.image, s.character_string ('>'), agent edit_image_tag)
			html_doc.edit (Tag_start.anchor, s.character_string ('>'), agent edit_anchor_tag)
			across << Attribute_start.alt, Attribute_start.title >> as start loop
				html_doc.edit (start.item, s.character_string ('"'), agent normalize_attribute_text)
			end
		end

	file_out_extension: ZSTRING
		do
			Result := related_file_extensions [1]
		end

	on_email_collected
		do
			File_system.make_directory (output_file_path.parent)
			is_html_updated := not output_file_path.exists or else last_header.date > output_file_path.modification_date_time
			if is_html_updated then
				lio.put_path_field (file_out_extension, output_file_path)
				lio.put_new_line
				lio.put_string_field ("Character set", line_source.encoding_name)
				lio.put_new_line
				write_html
			end
		end

	remove_old_files
		local
			l_dir: EL_DIRECTORY
		do
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

	set_header_subject
		do
			Precursor
			output_file_path := output_dir + last_header.subject
			output_file_path.add_extension (file_out_extension)
		end

	write_html
		local
			html_doc: ZSTRING
		do
			html_doc := html_lines.joined_lines
			edit (html_doc)
			File_system.write_plain_text (output_file_path, html_doc.to_utf_8 (False))
		end

	is_tag_start (start_index, end_index: INTEGER; substring: ZSTRING): BOOLEAN
		do
			Result := substring [start_index] /= '>' implies substring.is_space_item (start_index)
		end

feature {NONE} -- Editing

	close_empty_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.insert_character ('/', substring.count)
		end

	edit_anchor_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			s: EL_ZSTRING_ROUTINES
		do
			if is_tag_start (start_index, end_index, substring) then
				remove_attributes (Surplus_hyperlink_attributes, substring, start_index)
				substring.edit (Attribute_start.href, s.character_string ('"'), agent remove_localhost_ref)
			end
		end

	edit_image_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		-- remove surplus attributes: moz-do-not-send, height, width
		local
			pos_src: INTEGER; s: EL_ZSTRING_ROUTINES
		do
			if is_tag_start (start_index, end_index, substring) then
				remove_attributes (Surplus_image_attributes, substring, start_index)
				-- make sure src attribute is indented
				pos_src := substring.substring_index (Attribute_start.src, start_index)
				if pos_src > 0 and then substring.item (pos_src - 1) = '%N' then
					substring.insert_string (s.n_character_string (' ', 8), pos_src)
				end
				close_empty_tag (start_index, end_index, substring)

				substring.edit (Attribute_start.src, s.character_string ('"'), agent remove_localhost_ref)
			end
		end

	edit_list_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			if substring.is_substring_whitespace (start_index, end_index) then
				substring.wipe_out
			end
		end

	edit_text_tags (start_index, end_index: INTEGER; substring: ZSTRING)
		-- remove surplus breaks before closing tag eg: "<h1>Title<br>%N  </h1>"
		-- and remove empty
		local
			break_intervals: like intervals
		do
			if substring.is_substring_whitespace (start_index, end_index) then
				substring.wipe_out
			else
				break_intervals := intervals (substring, Tag.break.open)
				if not break_intervals.is_empty
					and then substring.is_substring_whitespace (break_intervals.last_upper + 1, end_index)
				then
					if substring [substring.count - 1] = 'p' then
						substring.remove_substring (break_intervals.last_lower, break_intervals.last_upper)
					else
						-- remove new line for headings
						substring.remove_substring (break_intervals.last_lower, end_index)
					end
				end
			end
		end

	normalize_attribute_text (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			list: EL_SPLIT_ZSTRING_LIST
		do
			create list.make_adjusted_by_string (substring, Line_feed_entity, {EL_STRING_ADJUST}.Both)
			if list.count > 1 then
				substring.share (list.joined_words)
			end
		end

	remove_attributes (list: LIST [ZSTRING]; substring: ZSTRING; start_index: INTEGER)
		local
			name_pos: INTEGER
		do
			across list as name loop
				name_pos := substring.substring_index (name.item, start_index)
				if name_pos > 0 then
					substring.remove_substring (name_pos, substring.index_of ('"', name_pos + name.item.count + 2))
				end
			end
		end

 	remove_trailing_breaks (start_index, end_index: INTEGER; substring: ZSTRING)
 		local
 			pos_trailing: INTEGER; trailing: ZSTRING; s: EL_ZSTRING_ROUTINES
 		do
 			if is_tag_start (start_index, end_index, substring) then
	 			pos_trailing := substring.substring_index (s.character_string ('>'), start_index) + 1
	 			if substring.substring_index (Tag.break.open, pos_trailing) > 0 then
		 			trailing := substring.substring (pos_trailing, end_index)
		 			trailing.replace_substring_all (Tag.break.open, Empty_string)
		 			substring.replace_substring (trailing, pos_trailing, end_index)
	 			end
 			end
 		end

	remove_localhost_ref (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			localhost_index: INTEGER
		do
			localhost_index := substring.substring_index (Localhost_domain, start_index)
			if localhost_index > 0 then
				substring.remove_substring (start_index, localhost_index + Localhost_domain.count - 1)
			end
		end

	substitute_html_entities (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			entity_name: ZSTRING
		do
			entity_name := substring.substring (start_index, end_index)
			if Entity_numbers.has_key (entity_name) then
				if Entity_numbers.found_item <= 62 then
					substring.share (xml_entity (Entity_numbers.found_item.to_character_8, False))
				else
					substring.share (hexadecimal_entity (Entity_numbers.found_item, False))
				end
			end
		end

feature {NONE} -- Deferred

	related_file_extensions: ARRAY [ZSTRING]
		deferred
		ensure
			at_least_one: Result.count >= 1
		end

feature {NONE} -- Internal attributes

	is_html_updated: BOOLEAN

	output_file_path: FILE_PATH

feature {NONE} -- Constants

	Unclosed_tags: ARRAY [ZSTRING]
		once
			Result := << "<br" >>
		end

	Line_feed_entity: ZSTRING
		once
			Result := "&#xA;"
		end

	Localhost_domain: ZSTRING
		once
			Result := "://localhost"
		end

	Surplus_image_attributes: EL_ZSTRING_LIST
		once
			Result := "moz-do-not-send, height, width, border"
		end

	Surplus_hyperlink_attributes: EL_ZSTRING_LIST
		once
			Result := Surplus_image_attributes [1] + ", class"
		end

end