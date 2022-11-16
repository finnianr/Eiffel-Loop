note
	description: "Copy file command interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	EL_COPY_FILE_COMMAND_I

inherit
	EL_FILE_RELOCATION_COMMAND_I
		redefine
			source_path
		end

feature -- Access

	source_path: FILE_PATH

	update: EL_BOOLEAN_OPTION
		-- copy only when the SOURCE file is newer than the destination file
		-- or when the destination file is missing

feature -- Status query

	is_recursive: BOOLEAN
		-- True if recursive copy
		do
			Result := False
		end
end