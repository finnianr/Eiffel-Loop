note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-03 18:53:54 GMT (Wednesday 3rd August 2016)"
	revision: "2"

class
	EIFFEL_SOURCE_TREE_PROCESSOR

inherit
	EL_DIRECTORY_TREE_FILE_PROCESSOR
		redefine
			make
		end

create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_path: like source_directory_path; editing_command: EIFFEL_EDITING_COMMAND)
			--
		do
			Precursor (a_path, editing_command)
			file_pattern := "*.e"
		end

end
