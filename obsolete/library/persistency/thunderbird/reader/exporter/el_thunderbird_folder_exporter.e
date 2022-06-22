note
	description: "[
		Export filtered contents of Thunderbird email folder as HTML and edited by
		class conforming to [$source EL_HTML_WRITER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-12 16:53:54 GMT (Friday 12th October 2018)"
	revision: "8"

deferred class
	EL_THUNDERBIRD_FOLDER_EXPORTER [WRITER -> EL_HTML_WRITER create make end]

inherit
	EL_THUNDERBIRD_FOLDER_READER
		rename
			read_mails as export_mails,
			html_lines as raw_html_lines
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
			create html_lines.make (50)
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

feature {NONE} -- State handlers

	find_end_tag (line: ZSTRING)
			--
		do
			if line.begins_with (end_tag_name) then
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

feature {NONE} -- Implementation

	as_xml (html_doc: ZSTRING): ZSTRING
		local
			part: EL_SPLIT_ZSTRING_LIST; buffer: ZSTRING
		do
			create part.make (html_doc, Html_break_tag)
			buffer := once_empty_string
			from part.start until part.after loop
				if part.index > 1 then
					buffer.append (Break_tag)
				end
				substitute_html_entities (part.item, buffer)
				part.forth
			end
			Result := buffer.twin
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

	extend_html (line: ZSTRING)
		do
			html_lines.extend (as_xml (line))
		end

	file_out_extension: ZSTRING
		do
			Result := related_file_extensions [1]
		end

	set_header_subject
		do
			Precursor
			output_file_path := output_dir + last_header.subject
			output_file_path.add_extension (file_out_extension)
		end

	substitute_html_entities (line, buffer: ZSTRING)
		local
			parts: EL_SPLIT_ZSTRING_LIST; semi_colon_pos: INTEGER
			part, entity_name: ZSTRING
		do
			create parts.make (line, Ampersand)
			if parts.count = 1 then
				buffer.append (line)
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

	html_lines: EL_ZSTRING_LIST

	is_html_updated: BOOLEAN

	output_file_path: EL_FILE_PATH

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

	Html_break_tag: ZSTRING
		-- <br>
		once
			Result := XML.open_tag ("br")
		end

end
