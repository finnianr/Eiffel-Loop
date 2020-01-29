note
	description: "Path that is settable either from `make' routine or user input"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 13:46:02 GMT (Wednesday 29th January 2020)"
	revision: "4"

class
	EL_INPUT_PATH [P -> EL_PATH create default_create end]

inherit
	EL_MAKEABLE_FROM_STRING [ZSTRING]
		redefine
			default_create
		end

	EL_MODULE_USER_INPUT

	EL_MODULE_LIO

create
	make, default_create

feature {NONE} -- Initialization

	make (a_path: ZSTRING)
		do
			make_default
			path.set_path (a_path)
		end

	make_default, default_create
		do
			create path
		end

feature -- Access

	path: P

feature -- Basic operations

	wipe_out
		-- make `path' empty
		do
			make_default
		end

feature -- Element change

	check_path (prompt: READABLE_STRING_GENERAL)
		-- assign user input to `path' if `path.is_empty'
		local
			input_path: ZSTRING
		do
			if path.is_empty then
				input_path := User_input.path (prompt)
				lio.put_new_line
				path.set_path (input_path)
			end
		end

	check_path_default
		-- call `check_path' with default prompt "Drag and drop X"
		do
			check_path (Default_prompt + Type_table.cached_item ({P}))
		end

feature -- Conversion

	to_string: ZSTRING
		do
			Result := path.to_string
		end

feature {NONE} -- Constants

	Default_prompt: ZSTRING
		once
			Result := "Drag and drop a "
		end

	Type_table: EL_TYPE_TABLE [STRING]
		once
			create Result.make (<<
				[{EL_FILE_PATH}, "file"],
				[{EL_DIR_PATH}, "directory"],
				[{EL_DIR_URI_PATH}, "URL"],
				[{EL_FILE_URI_PATH}, "URL"]
			>>)
		end

end
