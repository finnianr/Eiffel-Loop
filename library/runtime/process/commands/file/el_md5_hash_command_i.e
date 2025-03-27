note
	description: "Obtain MD5 hash using Unix [https://linux.die.net/man/1/md5sum md5sum command]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-26 17:29:09 GMT (Wednesday 26th March 2025)"
	revision: "1"

deferred class
	EL_MD5_HASH_COMMAND_I

inherit
	EL_FILE_PATH_OPERAND_COMMAND_I
		rename
			file_path as  target_path,
			set_file_path as  set_target_path
		export
			{NONE} execute
		undefine
			do_command, getter_function_table, is_captured, make_default, new_command_parts
		end

	EL_SECURE_SHELL_OS_COMMAND
		redefine
			getter_function_table
		end

	EL_CAPTURED_OS_COMMAND_I
		export
			{NONE} execute
		redefine
			make_default, getter_function_table
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			set_text
		end

feature -- Access

	digest_string: STRING
		do
			execute
			Result := internal_digest
		end

	mode: IMMUTABLE_STRING_8

feature -- Status query

	is_binary: BOOLEAN
		-- read in binary mode
		do
			Result := mode = Mode_option.binary
		end

	is_text: BOOLEAN
		-- read in text mode
		do
			Result := mode = Mode_option.text
		end

feature -- Status change

	set_binary
		-- md5sum --binary will compute the checksum including the \r\n
		do
			set_mode (Mode_option.binary)
		end

	set_text
		-- md5sum --text will normalize \r\n to \n
		do
			set_mode (Mode_option.text)
		end

feature {NONE} -- Implementation

	do_with_lines (line_source: like new_output_lines)
		do
			if attached i_th_line (line_source, 1) as line then
				internal_digest := line.substring_to (' ')
				internal_digest.to_upper
			else
				internal_digest.wipe_out
			end
		end

	set_mode (a_mode: IMMUTABLE_STRING_8)
		do
			mode := a_mode
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor {EL_CAPTURED_OS_COMMAND_I}
			Result.merge (Precursor {EL_SECURE_SHELL_OS_COMMAND})
		end

feature {NONE} -- Internal attributes

	internal_digest: STRING

feature {NONE} -- Constants

	Mode_option: TUPLE [text, binary: IMMUTABLE_STRING_8]
		once ("PROCESS")
			create Result
			Tuple.fill_immutable (Result, "text, binary")
		end

end