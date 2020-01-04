note
	description: "File tree command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_FILE_TREE_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_FILE_SYSTEM

	EL_ITERATION_OUTPUT

feature {NONE} -- Initialization

	make (a_tree_dir: like tree_dir)
		do
			tree_dir := a_tree_dir
		end

feature -- Basic operations

	execute
		local
			i: NATURAL; file_list: like new_file_list
		do
			file_list := new_file_list
			file_list.sort
			across file_list as path loop
				do_with_file (path.item)
				print_progress (i)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	do_with_file (file_path: EL_FILE_PATH)
		deferred
		end

	extension_list: ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			create Result.make_from_array (<< default_extension >>)
		end

	default_extension: READABLE_STRING_GENERAL
		deferred
		end

	new_file_list: EL_SORTABLE_ARRAYED_LIST [EL_FILE_PATH]
		do
			create Result.make (0)
			across extension_list as extension loop
				Result.append (File_system.recursive_files_with_extension (tree_dir, extension.item.to_string_32))
			end
		end

feature {NONE} -- Internal attributes

	tree_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Iterations_per_dot: NATURAL_32
		once
			Result := 60
		end

end
