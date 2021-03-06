note
	description: "Double path operand command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-10 14:19:13 GMT (Saturday 10th July 2021)"
	revision: "9"

deferred class
	EL_DOUBLE_PATH_OPERAND_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as source_path,
			set_path as set_source_path,
			make as make_source
		redefine
			getter_function_table
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

	getter_function_table: like getter_functions
			--
		local
			field_name: STRING
		do
			field_name := meta_data.field_list [2].name
			Result := Precursor +
				[field_name,				agent: ZSTRING do Result := destination_path.escaped end] +
				["is_file_destination", agent: BOOLEAN_REF do Result := is_file_destination.to_reference end]
		end

end