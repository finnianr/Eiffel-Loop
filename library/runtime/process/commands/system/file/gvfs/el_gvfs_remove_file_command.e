note
	description: "Summary description for {EL_GVFS_REMOVE_FILE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 14:24:12 GMT (Thursday 23rd June 2016)"
	revision: "3"

class
	EL_GVFS_REMOVE_FILE_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		rename
			make as make_command
		redefine
			on_error
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_command ("gvfs-rm $uri")
		end

feature {NONE} -- Event handling

	on_error
		do
			if not is_file_not_found (error_message) then
				Precursor
			end
		end

end
