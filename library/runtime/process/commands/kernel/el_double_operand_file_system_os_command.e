note
	description: "Summary description for {EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:06:38 GMT (Wednesday 16th December 2015)"
	revision: "5"

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

	set_directory_destination
			--
		do
			is_destination_a_normal_file := false
		end

	set_file_destination
			--
		do
			is_destination_a_normal_file := true
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := precursor
			Result.append_tuples (<<
				["source_path", 						agent: ZSTRING do Result := escaped_path (source_path) end],
				["destination_path", 				agent: ZSTRING do Result := escaped_path (destination_path) end],
				["is_destination_a_normal_file", agent: BOOLEAN_REF do Result := is_destination_a_normal_file.to_reference end],

				-- For Windows
				["xcopy_destination_path", 		agent xcopy_destination_path]
			>>)
		end

feature {NONE} -- Implementation

	xcopy_destination_path: ZSTRING
			-- For Windows recursive copy
		local
			destination_dir: EL_DIR_PATH
		do
			destination_dir := destination_path.to_string
			destination_dir.append_dir_path (source_path.base)
			Result := escaped_path (destination_dir)
		end

feature -- Constants

	Valid_destination_extension: ZSTRING
		once
			create Result.make_empty
		end
end
