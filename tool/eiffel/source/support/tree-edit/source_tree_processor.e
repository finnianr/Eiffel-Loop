note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 10:19:14 GMT (Monday 16th October 2017)"
	revision: "4"

class
	SOURCE_TREE_PROCESSOR

inherit
	EL_DIRECTORY_TREE_FILE_PROCESSOR
		redefine
			make
		end

create
	make

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_path: like source_directory_path; editing_command: EDITING_COMMAND)
			--
		do
			Precursor (a_path, editing_command)
			file_pattern := "*.e"
		end

end
