note
	description: "Summary description for {FILE_TREE_OPERATING_SUB_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 7:27:28 GMT (Monday 24th June 2013)"
	revision: "2"

deferred class
	FILE_TREE_OPERATING_SUB_APP

inherit
	PATH_OPERATING_SUB_APP [EL_DIR_PATH]
		rename
			input_path as tree_path
		redefine
			Input_path_option_name
		end

feature {NONE} -- Constants

	Input_path_option_description: STRING
		once
			Result :=  "Directory tree path"
		end

	Input_path_option_name: STRING
			--
		once
			Result := "source_tree"
		end

end
