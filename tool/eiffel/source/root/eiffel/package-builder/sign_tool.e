note
	description: "[
		Wrapper for [https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool Microsoft signtool]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-20 17:20:37 GMT (Tuesday 20th June 2023)"
	revision: "2"

class
	SIGN_TOOL

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			field_included as is_any_field,
			make_default as make,
			xml_naming as eiffel_naming
		end

	EL_MODULE_LIO; EL_MODULE_USER_INPUT

create
	make

feature -- Access

	exe_path: FILE_PATH

feature -- Status query

	has_certificate_path: BOOLEAN
		do
			Result := not certificate_path.is_empty
		end

	has_master_key: BOOLEAN
		do
			Result := not master_key_path.is_empty
		end

feature -- Element change

	set_exe_path (a_exe_path: FILE_PATH)
		do
			exe_path := a_exe_path
		end

feature -- Status change

	lock_certificate
		do
			if attached master_key_file as key_file and then key_file.is_unlocked then
				key_file.lock
			end
		end

	unlock_certificate
		do
			if has_certificate_path then
				pass_phrase := User_input.line ("Signing pass phrase")
				lio.put_new_line

			elseif has_master_key then
				create master_key_file.make (master_key_path)

			end
		end

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

feature {NONE} -- Internal attributes

	bin_dir: DIR_PATH

	certificate_path: FILE_PATH

	master_key_file: detachable EL_SECURE_KEY_FILE note option: transient attribute end

	master_key_path: FILE_PATH

	options_template: STRING

	pass_phrase: ZSTRING

feature {NONE} -- Constants

	Element_node_fields: STRING = "options_template"

	signtool_prefix: STRING = "signtool sign"

end