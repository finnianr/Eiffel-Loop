note
	description: "Summary description for {EL_COPY_TREE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:23:50 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_COPY_TREE_COMMAND

inherit
	EL_COPY_FILE_COMMAND
		redefine
			make, is_recursive, source_path, destination_path
		end

create
	make, make_default

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
