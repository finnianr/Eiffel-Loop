note
	description: "Windows implementation of ${EL_DELETE_TREE_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-22 13:34:05 GMT (Monday 22nd April 2024)"
	revision: "8"

class
	EL_DELETE_TREE_COMMAND_IMP

inherit
	EL_DELETE_TREE_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "[
		rmdir
		#if $recursive_enabled then
			/S
		#end
		/Q $target_path
	]"

end