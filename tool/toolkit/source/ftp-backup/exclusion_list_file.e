note
	description: "Summary description for {EXCLUSION_LIST_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:18:29 GMT (Sunday 20th December 2015)"
	revision: "6"

class
	EXCLUSION_LIST_FILE

inherit
	PLAIN_TEXT_FILE
		rename
			make as make_file,
			path as file_path
		export
			{NONE} all
			{ANY} name, file_path
		end

	FILE_SPECIFIER_LIST

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make (
		directory_node: EL_XPATH_NODE_CONTEXT; a_archive_directory_path, a_target_path: EL_DIR_PATH
	)
			--
		local
			l_file_path: EL_FILE_PATH
		do
			log.enter ("make")
			archive_directory_path := a_archive_directory_path
			target_path := a_target_path
			l_file_path := archive_directory_path + File_name
			l_file_path.enable_out_abbreviation

			make_open_write (l_file_path)

			log.put_path_field ("file_name", l_file_path)
			log.put_new_line

			write_specifiers (directory_node)

			close
			log.exit
		end

feature {NONE} -- Implementation

	put_file_specifier (specifier_name, file_specifier: ZSTRING)
			--
		do
			put_string (file_specifier)
			put_new_line
		end

	archive_directory_path: EL_DIR_PATH

	target_path: EL_DIR_PATH

feature {NONE} -- Constants

	Query_path: STRING_32
			--
		once
			Result := "filter/exclude"
		end

	File_name: STRING
			--
		once
			Result := "exclude.txt"
		end

	Info_heading: STRING
			--
		once
			Result := "EXCLUDE FILES:"
		end

end
