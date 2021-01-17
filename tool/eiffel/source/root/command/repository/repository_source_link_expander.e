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
	date: "2021-01-17 15:30:32 GMT (Sunday 17th January 2021)"
	revision: "10"

class
	REPOSITORY_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_PUBLISHER
		rename
			make as make_publisher
		redefine
			execute
		end

	SHARED_HTML_CLASS_SOURCE_TABLE

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
			pos_right_bracket, previous_pos: INTEGER
		do
			line.replace_substring_all (s.character_string ('%T'), Triple_space)
			previous_pos := 1
			create link.make (line, Wiki_source_link)
			from link.start until link.after loop
				pos_right_bracket := line.index_of (']', link.item_upper)
				file_out.put_string (line.substring (previous_pos, link.item_lower - 1))
				if pos_right_bracket > 0 and then line.is_space_item (link.item_upper + 1)
					and then Class_source_table.has_key (class_name (line.substring (link.item_upper + 2, pos_right_bracket - 1)))
				then
					file_out.put_raw_character_8 ('[')
					file_out.put_string (web_address)
					file_out.put_raw_character_8 ('/')
					file_out.put_string (Class_source_table.found_item)
					file_out.put_string (line.substring (link.item_upper + 1, pos_right_bracket))
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

feature {NONE} -- Initialization

	Wiki_source_link: ZSTRING
		once
			Result := "[$source"
		end

	file_path: EL_FILE_PATH

	Triple_space: ZSTRING
		once
			create Result.make_filled (' ', 3)
		end

end