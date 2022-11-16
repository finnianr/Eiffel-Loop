note
	description: "Gvfs remove file command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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