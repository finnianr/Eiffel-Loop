note
	description: "Unix implementation of [$source EL_OS_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-29 19:26:18 GMT (Wednesday 29th December 2021)"
	revision: "11"

deferred class
	EL_OS_COMMAND_IMP

inherit
	EL_OS_COMMAND_I
		export
			{NONE} all
		undefine
			getter_function_table, is_equal, make_default, Transient_fields
		end

	EL_OS_IMPLEMENTATION
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	new_output_lines (file_path: EL_FILE_PATH): EL_LINEAR [ZSTRING]
		do
			if file_path.exists then
				create {EL_PLAIN_TEXT_LINE_SOURCE} Result.make_utf_8 (file_path)
			else
				create {EL_ZSTRING_LIST} Result.make_empty
			end
		end

feature {NONE} -- Constants

	Command_prefix: STRING_32
		once
			create Result.make_empty
		end

end