note
	description: "Summary description for {EL_MOVE_FILE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-16 10:17:50 GMT (Wednesday 16th September 2015)"
	revision: "3"

class
	EL_MOVE_FILE_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	Template: STRING = "move $source_path $destination_path"

end
