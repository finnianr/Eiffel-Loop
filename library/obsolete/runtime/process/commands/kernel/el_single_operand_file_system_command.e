note
	description: "Summary description for {EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-13 16:22:33 GMT (Monday 13th June 2016)"
	revision: "6"

deferred class
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [T -> EL_OS_COMMAND_INTERFACE create default_create end]

inherit
	EL_FILE_SYSTEM_OS_COMMAND [T]
		redefine
			make_default, default_create
		end

feature {NONE} -- Initialization

	make_default
		do
			create {EL_DIR_PATH} path
			Precursor
		end

	default_create
		do
			make_default
		end

	make (a_path: like path)
			--
		do
			make_default
			path := a_path
		end

feature -- Access

	path: EL_PATH

feature -- Element change

	set_path (a_path: like path)
			--
		require
			valid_extension: is_valid_extension (a_path.extension)
		do
			path := a_path
		end

feature -- Contract Support

	is_valid_extension (extension: ZSTRING): BOOLEAN
		do
			Result := not Valid_extension.is_empty implies extension ~ Valid_extension
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["path", agent: ZSTRING do Result := escaped_path (path) end]
			>>)
		end

feature -- Constants

	Valid_extension: ZSTRING
		once
			create Result.make_empty
		end

end
