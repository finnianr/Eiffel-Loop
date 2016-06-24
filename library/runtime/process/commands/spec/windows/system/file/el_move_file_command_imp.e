note
	description: "Windows implementation of `EL_MOVE_FILE_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-17 17:54:11 GMT (Friday 17th June 2016)"
	revision: "5"

class
	EL_MOVE_FILE_COMMAND_IMP

inherit
	EL_MOVE_FILE_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "move $source_path $destination_path"

end
