note
	description: "Summary description for {EL_DELETE_TREE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 17:19:44 GMT (Monday 16th May 2016)"
	revision: "4"

class
	EL_DELETE_TREE_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	template: STRING = "rm -r $target_path"

end
