note
	description: "File tree command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_FILE_TREE_COMMAND

inherit
	EL_FILE_LIST_COMMAND

	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make (a_tree_dir: like tree_dir)
		do
			tree_dir := a_tree_dir
			make_default
		end

feature {NONE} -- Implementation

	file_extensions: READABLE_STRING_GENERAL
		-- comma separated list of file extensions
		deferred
		end

	new_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_with_count (0)
			across new_extensions_split as extension loop
				Result.append (File_system.files_with_extension (tree_dir, extension.item, True))
			end
		end

	new_extensions_split: EL_SPLIT_ZSTRING_ON_CHARACTER
		local
			extension_list: ZSTRING
		do
			create extension_list.make_from_general (file_extensions)
			create Result.make_adjusted (extension_list, ',', {EL_STRING_ADJUST}.Left)
		end

feature {NONE} -- Internal attributes

	tree_dir: DIR_PATH

end