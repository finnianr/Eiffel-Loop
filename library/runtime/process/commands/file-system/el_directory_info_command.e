note
	description: "Command to find file count and directory file content size"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-09 13:33:15 GMT (Wednesday 9th October 2013)"
	revision: "3"

class
	EL_DIRECTORY_INFO_COMMAND
	
inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [EL_DIRECTORY_INFO_COMMAND_IMPL]
		rename
			path as target_path,
			set_path as set_target_path
		redefine
			getter_function_table, line_processing_enabled, do_with_lines
		end

create
	make, make_default

feature -- Access

	size: INTEGER
		do
			Result := implementation.size
		end

	file_count: INTEGER
		do
			Result := implementation.file_count
		end

feature -- Status query

	line_processing_enabled: BOOLEAN
			--
		do
			Result := True
		end

feature {NONE} -- Implementation

	do_with_lines (a_lines: EL_FILE_LINE_SOURCE)
			--
		do
			implementation.do_with_lines (a_lines)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["target_path", agent: EL_PATH do Result := target_path end]
			>>)
		end

end
