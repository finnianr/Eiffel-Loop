note
	description: "Delete file or directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:05:52 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_DELETE_PATH_COMMAND

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [EL_DELETE_PATH_IMPL]
		rename
			path as target_path,
			set_path as set_target_path
		redefine
			getter_function_table
		end

create
	make, default_create

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["target_path", agent: ZSTRING do Result := escaped_path (target_path) end]
			>>)
		end

end