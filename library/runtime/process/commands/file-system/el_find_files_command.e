note
	description: "Summary description for {EL_FIND_FILES_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_FIND_FILES_COMMAND

inherit
	EL_FIND_OS_COMMAND [EL_FIND_FILES_IMPL, EL_FILE_PATH]
		rename
			make as make_find
		redefine
			getter_function_table, make_default, path_list
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			file_pattern := "*"
			enable_recursion
		end

	make (a_dir_path: like dir_path; a_file_pattern: like file_pattern)
			--
		do
			make_find (a_dir_path)
			file_pattern := a_file_pattern
		end

feature -- Access

	file_pattern: EL_ASTRING

	path_list: ARRAYED_LIST [EL_FILE_PATH]

feature -- Status query

	is_recursive_find: BOOLEAN

feature -- Element change

	set_file_pattern (a_file_pattern: like file_pattern)
			--
		do
			file_pattern := a_file_pattern
		end

feature {NONE} -- Evolicity reflection

	get_file_pattern: like file_pattern
			--
		do
			Result := file_pattern
		end

	getter_function_table: like getter_functions
			--
		do
			Result := precursor
			Result.append_tuples (<<
				["file_pattern", agent get_file_pattern]
			>>)
		end

end