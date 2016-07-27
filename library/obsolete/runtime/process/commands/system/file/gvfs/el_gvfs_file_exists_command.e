note
	description: "Summary description for {EL_GVFS_FILE_EXISTS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:08:08 GMT (Wednesday 16th December 2015)"
	revision: "3"

class
	EL_GVFS_FILE_EXISTS_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		redefine
			default_create, on_error, find_line, reset
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
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
			state := agent final
		end

feature {NONE} -- Event handling

	on_error (message: ZSTRING)
		do
			if not is_file_not_found (message) then
				Precursor (message)
			end
		end

end