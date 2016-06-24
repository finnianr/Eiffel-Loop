note
	description: "Unix implementation of `EL_MAKE_DIRECTORY_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-17 16:01:59 GMT (Friday 17th June 2016)"
	revision: "5"

class
	EL_MAKE_DIRECTORY_COMMAND_IMP

inherit
	EL_MAKE_DIRECTORY_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "mkdir $directory_path"
end
