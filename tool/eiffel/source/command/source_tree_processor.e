note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-22 11:34:25 GMT (Thursday 22nd February 2018)"
	revision: "6"

class
	SOURCE_TREE_PROCESSOR

inherit
	EL_DIRECTORY_TREE_FILE_PROCESSOR
		redefine
			make
		end

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_path: like source_directory_path; editing_command: EDITING_COMMAND)
			--
		do
			Precursor (a_path, editing_command)
			file_pattern := "*.e"
		end

end
