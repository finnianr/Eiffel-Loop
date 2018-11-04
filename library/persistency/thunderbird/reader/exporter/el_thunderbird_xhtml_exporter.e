note
	description: "Thunderbird folder to xhtml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-21 10:48:19 GMT (Sunday 21st October 2018)"
	revision: "2"

deferred class
	EL_THUNDERBIRD_XHTML_EXPORTER

inherit
	EL_THUNDERBIRD_FOLDER_READER
		rename
			read_mails as export_mails
		redefine
			make_default, export_mails, set_header_subject
		end

	EL_HTML_CONSTANTS

	EL_MODULE_TIME
	EL_MODULE_LIO
	EL_MODULE_DIRECTORY

	EL_SHARED_ONCE_STRINGS


feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create output_file_path
		end

feature -- Basic operations

	export_mails (mails_path: EL_FILE_PATH)
		do
			Precursor (mails_path)
			remove_old_files
		end

feature {NONE} -- Implementation

	edit (html_doc: ZSTRING)
		do
			-- Remove surplus breaks
			across Text_tags as tag loop
				html_doc.edit (tag.item.open, tag.item.close, agent remove_surplus_break)
			end

			-- Change <br> to <br/>
			across Unclosed_tags as tag loop
				html_doc.edit (tag.item, character_string ('>'), agent close_empty_tag)
			end
			html_doc.edit (character_string ('&'), character_string (';'), agent substitute_html_entities)
			html_doc.edit (Image_tag, character_string ('>'), agent edit_image_tag)
			html_doc.edit (Anchor_tag, character_string ('>'), agent edit_anchor_tag)
		end

	file_out_extension: ZSTRING
		do
			Result := related_file_extensions [1]
		end

	on_email_collected
		do
			File_system.make_directory (output_file_path.parent)
			if not output_file_path.exists or else last_header.date > output_file_path.modification_date_time then
				lio.put_path_field (file_out_extension, output_file_path)
				lio.put_new_line
				lio.put_string_field ("Character set", line_source.encoding_name)
				lio.put_new_line
				write_html
				is_html_updated := True
			else
				is_html_updated := False
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
			File_system.write_plain_text (output_file_path, html_doc.to_utf_8)
		end

feature {NONE} -- Editing

	close_empty_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.insert_character ('/', substring.count)
		end

	edit_anchor_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			if not substring.is_alpha_item (3) then
				remove_attributes (Surplus_hyperlink_attributes, substring, start_index)
				substring.edit (Link_attribute.href, character_string ('"'), agent remove_localhost_ref)
			end
		end

	edit_image_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		-- remove surplus attributes: moz-do-not-send, height, width
		local
			pos_src: INTEGER
		do
			remove_attributes (Surplus_image_attributes, substring, start_index)
			-- make sure src attribute is indented
			pos_src := substring.substring_index (Link_attribute.src, start_index)
			if pos_src > 0 and then substring.item (pos_src - 1) = '%N' then
				substring.insert_string (n_character_string (' ', 8), pos_src)
			end
			close_empty_tag (start_index, end_index, substring)

			substring.edit (Link_attribute.src, character_string ('"'), agent remove_localhost_ref)
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

	remove_surplus_break (start_index, end_index: INTEGER; substring: ZSTRING)
		-- remove surplus breaks before closing tag eg: "<h1>Title<br>%N  </h1>"
		local
			break_intervals: like intervals
		do
			break_intervals := intervals (substring, Html_break_tag)
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
				substring.share (XML.entity (Entity_numbers.found_item))
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

	output_file_path: EL_FILE_PATH

feature {NONE} -- Constants

	Empty_tag_close: ZSTRING
		once
			Result := "/>"
		end

	Html_break_tag: ZSTRING
		-- <br>
		once
			Result := XML.open_tag ("br")
		end

	Unclosed_tags: ARRAY [ZSTRING]
		once
			Result := << "<br" >>
		end

	Anchor_tag: ZSTRING
		once
			Result := "<a"
		end

	Image_tag: ZSTRING
		once
			Result := "<img"
		end

	Link_attribute: TUPLE [href, src: ZSTRING]
		once
			create Result
			Result.href := "href=%""
			Result.src := "src=%""
		end

	Localhost_domain: ZSTRING
		once
			Result := "://localhost"
		end

	Surplus_image_attributes: ARRAYED_LIST [ZSTRING]
		once
			create Result.make_from_array (<< "moz-do-not-send", "height", "width", "border" >>)
		end

	Surplus_hyperlink_attributes: ARRAYED_LIST [ZSTRING]
		once
			create Result.make_from_array (<< Surplus_image_attributes [1], "class" >>)
		end

	Text_tags: ARRAYED_LIST [TUPLE [open, close: ZSTRING]]
		once
			create Result.make (5)
			across << "h1", "h2", "h3", "h4", "p" >> as name loop
				Result.extend (XML.tag (name.item))
			end
		end

end
