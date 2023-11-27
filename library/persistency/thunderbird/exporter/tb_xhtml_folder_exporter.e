note
	description: "Thunderbird folder to XHTML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-27 7:26:38 GMT (Monday 27th November 2023)"
	revision: "37"

deferred class
	TB_XHTML_FOLDER_EXPORTER

inherit
	TB_FOLDER_EXPORTER
		redefine
			make_default, export_mails, set_output_file_path
		end

	XML_ESCAPE_ROUTINES
		rename
			entity as xml_entity
		end

	EL_MODULE_DATE_TIME; EL_MODULE_FILE
	EL_MODULE_LIO; EL_MODULE_DIRECTORY; EL_MODULE_EXCEPTION

	EL_CHARACTER_32_CONSTANTS; EL_HTML_CONSTANTS

	EL_SHARED_STRING_8_BUFFER_SCOPES

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			-- cannot be once routines because of complications setting routine target
			create edit_attributes_image_tag.make (<<
				["moz-do-not-send", 	agent omit],
				["height",				agent omit],
				["width",				agent omit],
				["border", 				agent omit],
				["src",					agent prune_localhost]
			>>)
			create edit_attributes_anchor_tag.make (<<
				["moz-do-not-send", 	agent omit],
				["class",				agent omit],
				["href", 				agent prune_localhost]
			>>)
		end

feature -- Basic operations

	export_mails (email_list: TB_EMAIL_LIST)
		do
			Precursor (email_list)
			remove_old_files (email_list)
		end

feature {NONE} -- Implementation

	check_paragraph_count (xhtml: STRING)
		-- check that there is at least one paragraph
		local
			xdoc: EL_XML_DOC_CONTEXT
		do
			create xdoc.make_from_string (xhtml)
			if xdoc.context_list ("//p").count = 0 then
				lio.put_labeled_string (output_file_path.base, "count (//p) = 0")
				lio.put_new_line
			end
		end

	edit (html_doc: ZSTRING)
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
				html_doc.edit (l_tag.item, char ('>'), agent close_empty_tag)
			end
			html_doc.edit (char ('&'), char (';'), agent substitute_html_entities)
			html_doc.edit (Tag_start.image, char ('>'), agent edit_image_tag)
			html_doc.edit (Tag_start.anchor, char ('>'), agent edit_anchor_tag)
			across << Attribute_start.alt, Attribute_start.title >> as start loop
				html_doc.edit (start.item, char ('"'), agent normalize_attribute_text)
			end
		end

	file_out_extension: ZSTRING
		do
			Result := related_file_extensions [1]
		end

	is_tag_start (start_index, end_index: INTEGER; target: ZSTRING): BOOLEAN
		do
			Result := target [start_index] /= '>' implies target.is_space_item (start_index)
		end

	write_lines (email: TB_EMAIL)
		do
			File_system.make_directory (output_file_path.parent)
			is_html_updated := not output_file_path.exists
										or else email.date > File.modification_time (output_file_path)
			if is_html_updated then
				lio.put_path_field (file_out_extension + " %S", output_file_path)
				lio.put_new_line
				lio.put_string_field ("Character set", email.content_type.encoding_name.as_upper)
				lio.put_new_line
				write_html (new_html_lines (email).joined_lines)
			end
			check_paragraph_count (File.plain_text (output_file_path))
		end

	remove_old_files (email_list: TB_EMAIL_LIST)
		local
			l_dir: EL_DIRECTORY
		do
			-- Remove old files that don't have a match in current `subject_set'
			create l_dir.make (output_dir)
			across related_file_extensions as extension loop
				across l_dir.files_with_extension (extension.item) as file_path loop
					if not email_list.has_subject (file_path.item.base_name) then
						lio.put_path_field ("Removing %S", file_path.item)
						lio.put_new_line
						File_system.remove_file (file_path.item)
					end
				end
			end
		end

	set_output_file_path (subject_line: ZSTRING)
		do
			output_file_path := output_dir + subject_line
			output_file_path.add_extension (file_out_extension)
		end

	write_html (html_doc: ZSTRING)
		do
			edit (html_doc)
			across String_8_scope as scope loop
				File.write_text (output_file_path, scope.copied_utf_8_item (html_doc))
			end
		end

feature {NONE} -- Editing

	close_empty_tag (start_index, end_index: INTEGER; target: ZSTRING)
		do
			target.insert_character ('/', target.count)
		end

	edit_anchor_tag (start_index, end_index: INTEGER; target: ZSTRING)
		do
			if is_tag_start (start_index, end_index, target) then
				edit_attributes_anchor_tag.do_with_attributes (target)
			end
		end

	edit_image_tag (start_index, end_index: INTEGER; target: ZSTRING)
		-- remove surplus attributes: moz-do-not-send, height, width
		do
			if is_tag_start (start_index, end_index, target) then
				edit_attributes_image_tag.do_with_attributes (target)
				close_empty_tag (start_index, end_index, target)
			end
		end

	edit_list_tag (start_index, end_index: INTEGER; target: ZSTRING)
		do
			if target.is_substring_whitespace (start_index, end_index) then
				target.wipe_out
			end
		end

	edit_text_tags (start_index, end_index: INTEGER; target: ZSTRING)
		-- remove surplus breaks before closing tag eg: "<h1>Title<br>%N  </h1>"
		-- and remove empty
		local
			break_intervals: like intervals
		do
			if target.is_substring_whitespace (start_index, end_index) then
				target.wipe_out
			else
				break_intervals := intervals (target, Tag.break.open)
				if not break_intervals.is_empty
					and then target.is_substring_whitespace (break_intervals.last_upper + 1, end_index)
				then
					if target [target.count - 1] = 'p' then
						target.remove_substring (break_intervals.last_lower, break_intervals.last_upper)
					else
						-- remove new line for headings
						target.remove_substring (break_intervals.last_lower, end_index)
					end
				end
			end
		end

	normalize_attribute_text (start_index, end_index: INTEGER; target: ZSTRING)
		local
			list: EL_SPLIT_ZSTRING_LIST
		do
			create list.make_adjusted_by_string (target, Line_feed_entity, {EL_SIDE}.Both)
			if list.count > 1 then
				target.share (list.joined_words)
			end
		end

	remove_trailing_breaks (start_index, end_index: INTEGER; target: ZSTRING)
		local
			pos_trailing: INTEGER; trailing: ZSTRING
		do
			if is_tag_start (start_index, end_index, target) then
	 			pos_trailing := target.substring_index (char ('>'), start_index) + 1
	 			if target.substring_index (Tag.break.open, pos_trailing) > 0 then
		 			trailing := target.substring (pos_trailing, end_index)
		 			trailing.replace_substring_all (Tag.break.open, Empty_string)
		 			target.replace_substring (trailing, pos_trailing, end_index)
	 			end
			end
		end

	substitute_html_entities (start_index, end_index: INTEGER; target: ZSTRING)
		local
			entity_name: ZSTRING
		do
			entity_name := target.substring (start_index, end_index)
			if Entity_numbers.has_key (entity_name) then
				if Entity_numbers.found_item <= 62 then
					target.share (xml_entity (Entity_numbers.found_item.to_character_8, False))
				else
					target.share (hexadecimal_entity (Entity_numbers.found_item, False))
				end
			end
		end

feature {NONE} -- Implementation

	omit (name, value, element: ZSTRING)
		-- do nothing with `name' and `value'
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
			XML.append_attribute (name, value, element)
		end

feature {NONE} -- Deferred

	related_file_extensions: EL_ZSTRING_LIST
		deferred
		ensure
			at_least_one: Result.count >= 1
		end

feature {NONE} -- Internal attributes

	edit_attributes_anchor_tag: TB_ATTRIBUTE_EDIT_TABLE
		-- cannot be once routines because of complications setting routine target

	edit_attributes_image_tag: TB_ATTRIBUTE_EDIT_TABLE

	is_html_updated: BOOLEAN

feature {NONE} -- Constants

	Line_feed_entity: ZSTRING
		once
			Result := "&#xA;"
		end

	Localhost_domain: ZSTRING
		once
			Result := "://localhost"
		end

	Unclosed_tags: EL_ZSTRING_LIST
		once
			Result := "<br"
		end

end