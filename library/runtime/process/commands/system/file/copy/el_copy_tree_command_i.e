note
	description: "Summary description for {EL_COPY_TREE_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_COPY_TREE_COMMAND_I

inherit
	EL_FILE_RELOCATION_COMMAND_I
		redefine
			source_path, destination_path
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