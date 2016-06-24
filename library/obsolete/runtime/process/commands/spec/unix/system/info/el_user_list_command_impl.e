note
	description: "Unix implementation of EL_USER_LIST_COMMAND"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-17 16:56:11 GMT (Tuesday 17th May 2016)"
	revision: "4"

class
	EL_USER_LIST_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature {NONE} -- Constants

	Template: STRING = "ls $path"

end
