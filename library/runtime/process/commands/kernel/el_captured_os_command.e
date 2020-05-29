note
	description: "General purpose OS command that captures output lines of substituted command template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-27 7:43:00 GMT (Wednesday 27th May 2020)"
	revision: "7"

class
	EL_CAPTURED_OS_COMMAND

inherit
	EL_OS_COMMAND
		undefine
			make_default, do_command, new_command_parts
		end

	EL_CAPTURED_OS_COMMAND_I
		rename
			template as Empty_string
		undefine
			has_variable, system_command, template_name, new_temporary_name, temporary_error_file_path, put_variable
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

	do_with_lines (a_lines: like adjusted_lines)
		do
			from a_lines.start until a_lines.after loop
				lines.extend (a_lines.item)
				a_lines.forth
			end
		end

end
