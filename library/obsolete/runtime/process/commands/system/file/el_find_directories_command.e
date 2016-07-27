note
	description: "Summary description for {EL_FIND_DIRECTORIES_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 16:03:43 GMT (Monday 16th May 2016)"
	revision: "5"

class
	EL_FIND_DIRECTORIES_COMMAND

inherit
	EL_FIND_OS_COMMAND [EL_FIND_DIRECTORIES_IMPL, EL_DIR_PATH]
		redefine
			path_list
		end

create
	default_create, make

feature -- Access

	path_list: EL_ARRAYED_LIST [EL_DIR_PATH]

end