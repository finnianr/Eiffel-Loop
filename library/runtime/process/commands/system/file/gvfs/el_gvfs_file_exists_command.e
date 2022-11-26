note
	description: "Gvfs file exists command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-26 7:25:58 GMT (Saturday 26th November 2022)"
	revision: "6"

class
	EL_GVFS_FILE_EXISTS_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		rename
			make as make_command
		redefine
			ignore, find_line, reset
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_name ("gvfs-info.type", "gvfs-info -a standard::type $uri")
		end

feature -- Access

	file_exists: BOOLEAN

feature -- Element change

	reset
		do
			file_exists := False
		end

feature {NONE} -- Line states

	find_line (line: ZSTRING)
		do
			file_exists := True
			state := final
		end

feature {NONE} -- Implementation

	ignore (a_error: ZSTRING): BOOLEAN
		do
			Result := is_file_not_found (a_error)
		end

end