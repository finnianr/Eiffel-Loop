note
	description: "[
		Use a supplied repository publishing configuration to expand `${<type-name>}' variable path in wiki-links 
		containined in a wiki-markup text file. Write the expanded output to file named as follows:
		
			<file name>.expanded.<file extension>
			
		An incidental function is to expand all tabs as 3 spaces.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-04 7:44:35 GMT (Tuesday 4th June 2024)"
	revision: "39"

class
	REPOSITORY_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_PUBLISHER
		rename
			make as make_publisher
		redefine
			execute
		end

	EL_APPLICATION_COMMAND

	EL_FILE_OPEN_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_file_path, a_config_path: FILE_PATH; a_version: STRING; a_thread_count: INTEGER)
		do
			make_publisher (a_config_path, a_version, a_thread_count)
			file_path := a_file_path
		end

feature -- Access

	Description: STRING = "Expand ${MY_CLASS} links in text file using repository configuration"

	expanded_file_path: FILE_PATH
		do
			Result := file_path.twin
			Result.base.prepend_compatible ("EXPANDED-")
		end

feature -- Basic operations

	execute
		do
			log_cpu_percentage

			from until user_quit loop
				if attached open (expanded_file_path, Write) as file_out then
					open_lines (file_path, Utf_8).do_all (agent expand_links (?, file_out))
					file_out.close
				end
				ask_user
			end
		end

	expand_links (line: ZSTRING; file_out: EL_PLAIN_TEXT_FILE)
		local
			previous_end_index, preceding_start_index, preceding_end_index: INTEGER
		do
			line.expand_tabs (3)
			if attached Class_link_list as list then
				list.fill (line)
				from list.start until list.after loop
					preceding_start_index := previous_end_index + 1
					preceding_end_index := list.item.start_index - 1
					if (preceding_end_index - preceding_start_index + 1) > 0 then
						file_out.put_string (line.substring (preceding_start_index, preceding_end_index))
					end
					file_out.put_string (list.item.wiki_markup (config.web_address))
					previous_end_index := list.item.end_index
					list.forth
				end
				if line.count - previous_end_index > 0 then
					file_out.put_string (line.substring (previous_end_index + 1, line.count))
				end
			end
			file_out.new_line
		end

feature {NONE} -- Internal attributes

	file_path: FILE_PATH

end