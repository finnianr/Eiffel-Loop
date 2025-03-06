note
	description: "Obtain MD5 hash using Unix [https://linux.die.net/man/1/md5sum md5sum command]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-06 8:59:12 GMT (Thursday 6th March 2025)"
	revision: "10"

class
	EL_MD5_HASH_COMMAND

inherit
	EL_CAPTURED_OS_COMMAND
		rename
			make as make_command,
			Var as Standard_var
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_command ("md5sum --$MODE $TARGET_PATH")
		end

	make_default
		do
			Precursor
			set_text
		end

feature -- Access

	digest_string: STRING
		do
			execute
			if has_error or else lines.is_empty then
				create Result.make_empty
			else
				Result := lines.first.substring_to (' ')
				Result.to_upper
			end
		end

	target_path: FILE_PATH

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

feature -- Element change

	set_target_path (a_path: FILE_PATH)
		do
			target_path := a_path
			put_path (Var.target_path, a_path)
		end

feature {NONE} -- Implementation

	set_mode (a_mode: IMMUTABLE_STRING_8)
		do
			mode := a_mode
			put_string (Var.mode, a_mode)
		end

feature {NONE} -- Constants

	Mode_option: TUPLE [text, binary: IMMUTABLE_STRING_8]
		once ("PROCESS")
			create Result
			Tuple.fill_immutable (Result, "text, binary")
		end

	Var: TUPLE [mode, target_path: STRING_8]
		once
			create Result
			Tuple.fill (Result, "MODE, TARGET_PATH")
		end

end