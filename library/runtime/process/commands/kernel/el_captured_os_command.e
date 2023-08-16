note
	description: "General purpose OS command that captures output lines of substituted command template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 13:29:44 GMT (Monday 31st July 2023)"
	revision: "13"

class
	EL_CAPTURED_OS_COMMAND

inherit
	EL_OS_COMMAND
		undefine
			make_default, is_captured, do_command, new_command_parts
		end

	EL_CAPTURED_OS_COMMAND_I
		rename
			template as Empty_string
		undefine
			getter_function_table, has_variable, system_command, template_name, new_temporary_name,
			temporary_error_file_path, put_any
		redefine
			make_default, do_command
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

	do_command (a_system_command: like system_command)
		do
			lines.wipe_out
			Precursor {EL_CAPTURED_OS_COMMAND_I} (a_system_command)
		end

	do_with_lines (a_lines: like new_output_lines)
		do
			from a_lines.start until a_lines.after loop
				lines.extend (a_lines.item)
				a_lines.forth
			end
		end

end