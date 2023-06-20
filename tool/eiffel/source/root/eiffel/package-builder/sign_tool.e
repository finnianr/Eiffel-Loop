note
	description: "[
		[https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool signtool] wrapper command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-19 15:20:09 GMT (Monday 19th June 2023)"
	revision: "1"

class
	SIGN_TOOL

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			field_included as is_any_field,
			make_default as make,
			xml_naming as eiffel_naming
		end

create
	make

feature -- Access

	bin_dir: DIR_PATH

	certificate_path: FILE_PATH

	master_key_path: FILE_PATH

	exe_path: FILE_PATH

	options_template: STRING

	pass_phrase: STRING

feature -- Basic operations

	sign_exe (on_error: EL_EVENT_LISTENER)
		do
			if attached new_signtool_command as cmd then
				if not bin_dir.is_empty then
					cmd.set_working_directory (bin_dir)
				end
				cmd.put_object (Current)
				cmd.execute
				if cmd.has_error then
					on_error.notify
					cmd.print_error ("signing")
				end
			end
		end

feature {NONE} -- Implementation

	new_signtool_command: EL_OS_COMMAND
		local
			lines: EL_STRING_8_LIST
		do
			create lines.make_with_lines (options_template)
			lines.put_front (Signtool_prefix)
			create Result.make (lines.joined_words)
		end

feature {NONE} -- Constants

	Element_node_fields: STRING = "options_template"

	signtool_prefix: STRING = "signtool sign"

end