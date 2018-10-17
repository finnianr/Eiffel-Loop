note
	description: "Thunderbird folder to xhtml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 17:13:13 GMT (Wednesday 17th October 2018)"
	revision: "1"

deferred class
	EL_THUNDERBIRD_FOLDER_TO_XHTML

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
		local
			l_dir: EL_DIRECTORY
		do
			Precursor (mails_path)
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

feature {NONE} -- Implementation

	edit (html_doc: ZSTRING)
		do
			across << "<br", "<img" >> as tag loop
				html_doc.edit (tag.item, once ">", agent close_empty_tag)
			end
			html_doc.edit (character_string ('&'), character_string (';'), agent substitute_html_entities)
			html_doc.edit (Image_tag, Empty_tag_close, agent edit_image_tag)
			across << "href=%"", "src=%"" >> as left loop
				html_doc.edit (left.item, character_string ('"'), agent remove_localhost_ref)
			end
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

	edit_image_tag (start_index, end_index: INTEGER; substring: ZSTRING)
		-- remove surplus attributes: moz-do-not-send, height, width
		local
			index: INTEGER
		do
			across Surplus_image_attributes as name loop
				index := substring.substring_index_general (name.item, start_index)
				if index > 0 then
					if substring.item (index - 1) = ' ' then
						index := index - 1
					end
					substring.remove_substring (index, substring.index_of ('"', index + name.item.count + 2))
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

	end_tag_name: ZSTRING
		deferred
		end

	related_file_extensions: ARRAY [ZSTRING]
		deferred
		ensure
			at_least_one: Result.count >= 1
		end

feature {NONE} -- Internal attributes

	is_html_updated: BOOLEAN

	output_file_path: EL_FILE_PATH

feature {NONE} -- Constants

	Break_tag: ZSTRING
		-- <br/>
		once
			Result := XML.empty_tag ("br")
		end

	Empty_tag_close: ZSTRING
		once
			Result := "/>"
		end

	Html_break_tag: ZSTRING
		-- <br>
		once
			Result := XML.open_tag ("br")
		end

	Image_tag: ZSTRING
		once
			Result := "<img"
		end

	Localhost_domain: ZSTRING
		once
			Result := "://localhost"
		end

	Surplus_image_attributes: ARRAY [STRING]
		once
			Result := << "moz-do-not-send", "height", "width" >>
		end

end
