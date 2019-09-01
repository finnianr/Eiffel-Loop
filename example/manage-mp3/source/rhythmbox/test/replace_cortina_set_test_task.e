note
	description: "Replace cortina set test task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 15:48:04 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	REPLACE_CORTINA_SET_TEST_TASK

inherit
	REPLACE_CORTINA_SET_TASK
		undefine
			root_node_name
		redefine
			user_input_file_path
		end

	TEST_MANAGEMENT_TASK
		undefine
			error_check, user_input_file_path, make_default
		end

feature {NONE} -- Implementation

	user_input_file_path (name: ZSTRING): EL_FILE_PATH
		do
			Result := music_dir + "Recent/March 23/09_-_Fabrizio_De_Andrè_Disamistade.mp3"
		end

end
