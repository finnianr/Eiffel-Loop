note
	description: "[
		App to change syntax of default_pointers references: 
			ptr /= default_pointer TO is_attached (ptr)
			and ptr = default_pointer TO not is_attached (ptr)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 12:51:38 GMT (Tuesday 18th February 2020)"
	revision: "7"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_APP

inherit
	SOURCE_TREE_EDIT_COMMAND_LINE_SUB_APP
		redefine
			Option_name, test_run
		end

create
	make

feature {NONE} -- Implementation

	new_editor (file_path_list: LIST [EL_FILE_PATH]): UPGRADE_DEFAULT_POINTER_SYNTAX_EDITOR
		do
			create Result.make
		end

feature -- Testing	

	test_run
			--
		do
			Test.do_file_tree_test ("sample-source/default_pointer", agent test_source_tree, checksum)
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 1575544618

	Option_name: STRING = "upgrade_default_pointer_syntax"

	Description: STRING = "[
		Change syntax of default_pointer references: 
		
			ptr /= default_pointer TO is_attached (ptr)
			ptr = default_pointer TO not is_attached (ptr)
	]"

end
