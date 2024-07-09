note
	description: "Obtain MD5 hash using Unix [https://linux.die.net/man/1/md5sum md5sum command]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 8:39:57 GMT (Tuesday 9th July 2024)"
	revision: "9"

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
			set_text_mode
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

feature -- Status query

	is_binary: BOOLEAN
		-- read in binary mode

	is_text: BOOLEAN
		-- read in text mode
		do
			Result := not is_binary
		end

feature -- Status change

	set_binary (enabled: BOOLEAN)
		do
			is_binary := enabled
			set_mode (Binary_mode [enabled])
		end

	set_binary_mode
		do
			set_binary (True)
		end

	set_text_mode
		do
			set_binary (False)
		end

feature -- Element change

	set_target_path (a_path: FILE_PATH)
		do
			target_path := a_path
			put_path (Var.target_path, a_path)
		end

feature {NONE} -- Implementation

	set_mode (mode: STRING)
		do
			put_string (Var.mode, mode)
		end

feature {NONE} -- Constants

	Binary_mode: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("text", "binary")
		end

	Var: TUPLE [mode, target_path: STRING_8]
		once
			create Result
			Tuple.fill (Result, "MODE, TARGET_PATH")
		end

end