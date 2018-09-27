note
	description: "Gvfs remove file command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

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