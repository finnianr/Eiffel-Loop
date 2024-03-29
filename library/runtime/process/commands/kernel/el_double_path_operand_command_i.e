note
	description: "Double path operand command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "13"

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
			Result := attached {FILE_PATH} destination_path
		end

feature -- Element change

	set_destination_path (a_destination_path: like destination_path)
			--
		do
			destination_path := a_destination_path
		end

feature {NONE} -- Evolicity reflection

	get_is_file_destination: BOOLEAN_REF
		-- is destination path a file
		do
			Result := is_file_destination.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor + ["is_file_destination", agent get_is_file_destination]
		end

end