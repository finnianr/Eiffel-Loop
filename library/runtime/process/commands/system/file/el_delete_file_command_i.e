note
	description: "Summary description for {EL_DELETE_FILE_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-20 7:27:40 GMT (Monday 20th June 2016)"
	revision: "1"

deferred class
	EL_DELETE_FILE_COMMAND_I

inherit
	EL_DELETION_COMMAND_I
		redefine
			target_path
		end

feature -- Access

	target_path: EL_FILE_PATH

end