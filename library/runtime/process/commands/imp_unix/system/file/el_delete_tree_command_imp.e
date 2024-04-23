note
	description: "Unix implementation of ${EL_DELETE_TREE_COMMAND_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-22 13:33:30 GMT (Monday 22nd April 2024)"
	revision: "8"

class
	EL_DELETE_TREE_COMMAND_IMP

inherit
	EL_DELETE_TREE_COMMAND_I

	EL_OS_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "[
		rm
		#if $recursive_enabled then
			--recursive
		#end
		$target_path
	]"

end