note
	description: "[
		Use a supplied repository publishing configuration to expand `$source' variable path in wiki-links 
		containined in a wiki-markup text file. Write the expanded output to file named as follows:
		
			<file name>.expanded.<file extension>
			
		An incidental function is to expand all tabs as 3 spaces.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-04 12:09:28 GMT (Thursday 4th March 2021)"
	revision: "13"

class
	REPOSITORY_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_PUBLISHER
		rename
			make as make_publisher
		redefine
			execute
		end

	SHARED_CLASS_PATH_TABLE

	SHARED_ISE_CLASS_TABLE

	EL_FILE_OPEN_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_file_path, a_config_path: EL_FILE_PATH; a_version: STRING; a_thread_count: INTEGER)
		do
			make_publisher (a_config_path, a_version, a_thread_count)
			file_path := a_file_path
		end

feature -- Access

	expanded_file_path: EL_FILE_PATH
		do
			Result := file_path.with_new_extension ("expanded." + file_path.extension)
		end

feature -- Basic operations

	execute
		do
			log_thread_count
			ecf_list.do_all (agent {EIFFEL_CONFIGURATION_FILE}.read_source_files (parser))
			if attached open (expanded_file_path, Write) as file_out then
				open_lines (file_path, Utf_8).do_all (agent expand_links (?, file_out))
				file_out.close
			end
		end

	expand_links (line: ZSTRING; file_out: EL_PLAIN_TEXT_FILE)
		local
			link: EL_OCCURRENCE_INTERVALS [ZSTRING]; s: EL_ZSTRING_ROUTINES
			pos_right_bracket, previous_pos: INTEGER; link_text, inside_text: ZSTRING
		do
			line.replace_substring_all (s.character_string ('%T'), Triple_space)
			previous_pos := 1
			create link.make (line, Wiki_source_link)
			from link.start until link.after loop
				pos_right_bracket := line.index_of (']', link.item_upper)
				file_out.put_string (line.substring (previous_pos, link.item_lower - 1))
				if pos_right_bracket > 0 and then line.is_space_item (link.item_upper + 1)then
					link_text := line.substring (link.item_upper + 1, pos_right_bracket)
					inside_text := link_text.substring (2, link_text.count - 1)
					if Class_path_table.has_class (inside_text) then
						put_source_link (file_out, Class_path_table.found_item, link_text)
					elseif ISE_class_table.has_class (inside_text) then
						put_ise_source_link (file_out, ISE_class_table.found_item, link_text)
					end
					previous_pos := pos_right_bracket + 1
				else
					file_out.put_string (Wiki_source_link)
					previous_pos := link.item_upper + 1
				end
				link.forth
			end
			file_out.put_string (line.substring (previous_pos, line.count))
			file_out.put_new_line
		end

feature {NONE} -- Implementation

	put_source_link (file_out: EL_PLAIN_TEXT_FILE; html_path: EL_FILE_PATH; link_text: ZSTRING)
		do
			file_out.put_raw_character_8 ('[')
			file_out.put_string (web_address)
			file_out.put_raw_character_8 ('/')
			file_out.put_string (html_path)
			file_out.put_string (link_text)
		end

	put_ise_source_link (file_out: EL_PLAIN_TEXT_FILE; url: ZSTRING; link_text: ZSTRING)
		do
			file_out.put_raw_character_8 ('[')
			file_out.put_string (url)
			file_out.put_string (link_text)
		end

feature {NONE} -- Internal attributes

	file_path: EL_FILE_PATH

feature {NONE} -- Constants

	Triple_space: ZSTRING
		once
			create Result.make_filled (' ', 3)
		end

	Wiki_source_link: ZSTRING
		once
			Result := "[$source"
		end

end