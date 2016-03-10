note
	description: "Summary description for {EL_GVFS_REMOVE_FILE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:08:26 GMT (Wednesday 16th December 2015)"
	revision: "3"

class
	EL_GVFS_REMOVE_FILE_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		redefine
			default_create, on_error
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			make ("gvfs-rm $uri")
		end

feature {NONE} -- Event handling

	on_error (message: ZSTRING)
		do
			if not is_file_not_found (message) then
				Precursor (message)
			end
		end

end
