note
	description: "Single path operand command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 11:58:48 GMT (Wednesday 31st October 2018)"
	revision: "6"

deferred class
	EL_SINGLE_PATH_OPERAND_COMMAND_I

inherit
	EL_OS_COMMAND_I
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make (a_path: like path)
			--
		do
			make_default
			path := a_path
		end

	make_default
		do
			path := Default_path
			Precursor
		end

feature -- Access

	path: like Default_path

feature -- Element change

	set_path (a_path: like path)
			--
		do
			path := a_path
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				[var_name_path, agent: ZSTRING do Result := path.escaped end]
			>>)
		end

	var_name_path: STRING
		do
			Result := "path"
		end

feature {NONE} -- Constants

	Default_path: EL_PATH
		once
			create {EL_DIR_PATH} Result
		end
end
