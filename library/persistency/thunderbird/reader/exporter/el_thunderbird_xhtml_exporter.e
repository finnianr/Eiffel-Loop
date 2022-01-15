note
	description: "Thunderbird folder to xhtml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-15 15:07:27 GMT (Saturday 15th January 2022)"
	revision: "14"

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
	EL_MODULE_REUSABLE

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

	is_tag_start (start_index, end_index: INTEGER; substring: ZSTRING): BOOLEAN
		do
			Result := substring [start_index] /= '>' implies substring.is_space_item (start_index)
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

feature {NONE} -- Editing

	close_empty_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.insert_character ('/', substring.count)
		end

	edit_anchor_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			if is_tag_start (start_index, end_index, substring) then
				do_with_attributes (substring, Edit_attributes_anchor_tag)
			end
		end

	edit_image_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		-- remove surplus attributes: moz-do-not-send, height, width
		do
			if is_tag_start (start_index, end_index, substring) then
				do_with_attributes (substring, Edit_attributes_image_tag)
				close_empty_tag (start_index, end_index, substring)
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

feature {NONE} -- Implementation

	append_attribute (name, value, element: ZSTRING)
		do
			if value.count > 0 then
				element.append_character (' ')
				element.append (name)
				element.append_character ('=')
				element.append_character ('"')
				element.append (value)
				element.append_character ('"')
			end
		end

	attribute_name_index (element: ZSTRING): INTEGER
		local
			i: INTEGER
		do
			from i := 2 until element.is_space_item (i) loop
				i := i + 1
			end
			from until element.is_alpha_item (i) or else i = element.count loop
				i := i + 1
			end
			Result := i
		end

	do_with_attributes (element: ZSTRING; action_table: EL_ATTRIBUTE_EDIT_TABLE)
		-- edit attributes in `element' using edit procedure in `action_table'
		require
			is_element: element.enclosed_with ("<>")
		local
			start_index, end_index: INTEGER
			name, ending: ZSTRING; quote_splitter: EL_SPLIT_ON_CHARACTER [ZSTRING]
		do
			start_index := element.index_of ('=', 1)
			if start_index > 0 then
				start_index := attribute_name_index (element)
				from end_index := element.count - 1 until element [end_index] = '"' or else end_index = 0 loop
					end_index := end_index - 1
				end
				if start_index < end_index then
					across Reuseable.string as reuse loop
						reuse.item.append_substring (element, start_index, end_index)
						create quote_splitter.make_adjusted (reuse.item, '"', {EL_STRING_ADJUST}.Both)
						ending := element.substring_end (end_index + 1)
						element.keep_head (start_index - 1)
						element.right_adjust
						across quote_splitter as split loop
							if split.cursor_index \\ 2 = 1 then
								name := split.item_copy
								name.remove_tail (1)
								name.right_adjust
								action_table.search (name)
							elseif action_table.found then
								action_table.found_item.set_target (Current)
								action_table.found_item (name, split.item, element)
							else
								append_attribute (name, split.item, element)
							end
						end
						element.append (ending)
					end
				end
			end
		end

	omit (name, value, element: ZSTRING)
		-- omit attribute from list
		do
		end

	prune_localhost (name, value, element: ZSTRING)
		-- omit attribute from list
		local
			localhost_index: INTEGER
		do
			localhost_index := value.substring_index (Localhost_domain, 1)
			if localhost_index > 0 then
				value.remove_substring (1, localhost_index + Localhost_domain.count - 1)
			end
			append_attribute (name, value, element)
		end

feature {NONE} -- Deferred

	related_file_extensions: EL_ZSTRING_LIST
		deferred
		ensure
			at_least_one: Result.count >= 1
		end

feature {NONE} -- Internal attributes

	is_html_updated: BOOLEAN

	output_file_path: FILE_PATH

feature {NONE} -- Constants

	Line_feed_entity: ZSTRING
		once
			Result := "&#xA;"
		end

	Localhost_domain: ZSTRING
		once
			Result := "://localhost"
		end

	Edit_attributes_anchor_tag: EL_ATTRIBUTE_EDIT_TABLE
		once
			create Result.make (<<
				["moz-do-not-send", 	agent omit],
				["class",				agent omit],
				["href", 				agent prune_localhost]
			>>)
		end

	Edit_attributes_image_tag: EL_ATTRIBUTE_EDIT_TABLE
		once
			create Result.make (<<
				["moz-do-not-send", 	agent omit],
				["height",				agent omit],
				["width",				agent omit],
				["border", 				agent omit],
				["src",					agent prune_localhost]
			>>)
		end

	Unclosed_tags: EL_ZSTRING_LIST
		once
			Result := "<br"
		end

end