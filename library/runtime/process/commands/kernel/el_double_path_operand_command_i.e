note
	description: "Double path operand command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-09 9:18:21 GMT (Sunday 9th September 2018)"
	revision: "7"

deferred class
	EL_DOUBLE_PATH_OPERAND_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as source_path,
			set_path as set_source_path,
			make as make_source
		redefine
			getter_function_table, var_name_path
		end

feature {NONE} -- Initialization

	make (a_source_path: like source_path; a_destination_path: like destination_path)
			--
		do
			make_source (a_source_path)
			set_destination_path (a_destination_path)
		end

feature -- Access

	destination_path: EL_PATH

feature -- Status query

	is_file_destination: BOOLEAN
		-- is destination path a file
		do
			Result := attached {EL_FILE_PATH} destination_path
		end

feature -- Element change

	set_destination_path (a_destination_path: like destination_path)
			--
		do
			destination_path := a_destination_path
		end

feature {NONE} -- Evolicity reflection

	var_name_path: ZSTRING
		do
			Result := "source_path"
		end

	var_name_path_2: ZSTRING
		do
			Result := "destination_path"
		end

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				[var_name_path_2, 		agent: ZSTRING do Result := destination_path.escaped end] +
				["is_file_destination", agent: BOOLEAN_REF do Result := is_file_destination.to_reference end]
		end

end
