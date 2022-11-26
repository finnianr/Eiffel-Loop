note
	description: "Gvfs remove file command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-26 7:25:58 GMT (Saturday 26th November 2022)"
	revision: "7"

class
	EL_GVFS_REMOVE_FILE_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		rename
			make as make_command
		redefine
			ignore
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_command ("gvfs-rm $uri")
		end

feature {NONE} -- Implementation

	ignore (a_error: ZSTRING): BOOLEAN
		do
			Result := is_file_not_found (a_error)
		end
end