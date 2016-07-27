note
	description: "Summary description for {EL_DOUBLE_PATH_OPERAND_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 7:23:12 GMT (Thursday 23rd June 2016)"
	revision: "6"

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
			Result := precursor
			Result.append_tuples (<<
				[var_name_path_2, 		agent: ZSTRING do Result := escaped_path (destination_path) end],
				["is_file_destination", agent: BOOLEAN_REF do Result := is_file_destination.to_reference end]
			>>)
		end

end