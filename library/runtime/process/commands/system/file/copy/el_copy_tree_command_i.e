note
	description: "Copy tree command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_COPY_TREE_COMMAND_I

inherit
	EL_FILE_RELOCATION_COMMAND_I
		redefine
			source_path, destination_path
		end

feature -- Access

	source_path: DIR_PATH

	destination_path: DIR_PATH

feature -- Status query

	is_recursive: BOOLEAN
		-- True if recursive copy
		do
			Result := True
		end

end