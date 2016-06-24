note
	description: "Summary description for {EL_COPY_TREE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 18:33:32 GMT (Thursday 1st January 2015)"
	revision: "3"

class
	EL_COPY_TREE_COMMAND

inherit
	EL_COPY_FILE_COMMAND
		redefine
			make, is_recursive, source_path, destination_path
		end

create
	make, default_create

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like source_path)
			--
		do
			Precursor (a_source_path, a_destination_path)
			is_destination_a_normal_file := False
		end

feature -- Access

	source_path: EL_DIR_PATH

	destination_path: EL_DIR_PATH

feature -- Status query

	is_recursive: BOOLEAN
		-- True if recursive copy
		do
			Result := True
		end

end
