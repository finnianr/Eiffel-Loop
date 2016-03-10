note
	description: "Summary description for {EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-12 11:33:15 GMT (Saturday 12th October 2013)"
	revision: "3"

class
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [T -> EL_COMMAND_IMPL create make end]

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [T]
		rename
			path as source_path,
			set_path as set_source_path,
			make as make_source
		redefine
			getter_function_table
		end

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like source_path)
			--
		do
			make_source (a_source_path)
			set_destination_path (a_destination_path)
		end

feature -- Access

	destination_path: EL_PATH

feature -- Status query

	is_destination_a_normal_file: BOOLEAN
		-- Default is directory

feature -- Element change

	set_destination_path (a_destination_path: like destination_path)
			--
		require
			valid_extension: not Valid_destination_extension.is_empty
								implies a_destination_path.extension ~ Valid_destination_extension
		do
			destination_path := a_destination_path
			is_destination_a_normal_file := attached {EL_FILE_PATH} destination_path as file_path
		end

	set_file_destination
			--
		do
			is_destination_a_normal_file := true
		end

	set_directory_destination
			--
		do
			is_destination_a_normal_file := false
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := precursor
			Result.append_tuples (<<
				["source_path", 						agent: EL_PATH do Result := source_path end],
				["destination_path", 				agent: EL_PATH do Result := destination_path end],

				["source_last_step", 				agent: ASTRING do Result := source_path.base end],
				["is_destination_a_normal_file", agent: BOOLEAN_REF do Result := is_destination_a_normal_file.to_reference end]
			>>)
		end

feature -- Constants

	Valid_destination_extension: ASTRING
		once
			create Result.make_empty
		end
end
