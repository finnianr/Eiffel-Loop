note
	description: "Summary description for {EL_MOVE_FILE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-17 10:09:35 GMT (Tuesday 17th May 2016)"
	revision: "1"

class
	EL_MOVE_FILE_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	Template: STRING = "move $source_path $destination_path"

end