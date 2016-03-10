note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 7:51:29 GMT (Monday 24th June 2013)"
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

feature {EL_COMMAND_LINE_SUB_APPLICATTION} -- Initialization

	make (a_path: like source_directory_path; a_file_processor: EL_FILE_PROCESSOR)
			--
		do
			Precursor (a_path, a_file_processor)
			file_pattern := "*.e"
		end

end -- class EIFFEL_SOURCE_TREE_PROCESSOR

