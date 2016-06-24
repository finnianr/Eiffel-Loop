note
	description: "Summary description for {EL_DELETE_PATH_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-17 11:31:55 GMT (Tuesday 17th May 2016)"
	revision: "3"

class
	EL_DELETE_PATH_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	template: STRING = "del $target_path"

end
