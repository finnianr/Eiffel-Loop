note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "3"

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

	make (a_path: like source_directory_path; a_file_processor: EL_FILE_PROCESSOR)
			--
		do
			Precursor (a_path, a_file_processor)
			file_pattern := "*.e"
		end

end -- class EIFFEL_SOURCE_TREE_PROCESSOR

