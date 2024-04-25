note
	description: "General purpose OS command that captures output lines of substituted command template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-25 9:29:30 GMT (Thursday 25th April 2024)"
	revision: "15"

class
	EL_CAPTURED_OS_COMMAND

inherit
	EL_OS_COMMAND
		undefine
			make_default, is_captured, do_command, new_command_parts, reset
		end

	EL_CAPTURED_OS_COMMAND_I
		rename
			template as Empty_string
		undefine
			getter_function_table, has_variable, system_command, template_name, new_temporary_name,
			temporary_error_file_path, put_any
		redefine
			make_default, reset
		end

create
	make, make_with_name

feature {NONE} -- Initialization

	make_default
			--
		do
			create lines.make (5)
			Precursor
		end

feature -- Access

	lines: EL_ZSTRING_LIST
		-- captured output

feature {NONE} -- Implementation

	reset
		do
			lines.wipe_out
			Precursor
		end

	do_with_lines (list: like new_output_lines)
		do
			from list.start until list.after loop
				lines.extend (list.item)
				list.forth
			end
		end

end