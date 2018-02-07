note
	description: "General purpose OS command that captures output lines of substituted command template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_CAPTURED_OS_COMMAND

inherit
	EL_OS_COMMAND
		undefine
			make_default, do_command, new_command_string
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			template_name, new_temporary_name, temporary_error_file_path
		redefine
			make_default
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

	do_with_lines (a_lines: like adjusted_lines)
		do
			from a_lines.start until a_lines.after loop
				lines.extend (a_lines.item)
				a_lines.forth
			end
		end

end
