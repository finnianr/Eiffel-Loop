indexing
	description: "Summary description for {EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [T]
		rename
			path as source_path,
			set_path as set_source_path,
			get_path as get_source_path,
			make as make_source
		redefine
			Getter_functions
		end

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like source_path) is
			--
		do
			make_source (a_source_path)
			destination_path := a_destination_path

			if {file_path: FILE_NAME} a_destination_path then
				is_destination_a_normal_file := true
			end
		end

feature -- Access

	destination_path: PATH_NAME

feature -- Status query

	is_destination_a_normal_file: BOOLEAN
		-- Default is directory

feature -- Element change

	set_destination_path (a_destination_path: like destination_path) is
			--
		do
			destination_path := a_destination_path
		end

	set_file_destination is
			--
		do
			is_destination_a_normal_file := true
		end

	set_directory_destination is
			--
		do
			is_destination_a_normal_file := false
		end


feature {NONE} -- Evolicity reflection

	get_destination_path: STRING is
			--
		do
			Result := destination_path
		end

	get_is_destination_a_normal_file: BOOLEAN_REF is
			--
		do
			Result := is_destination_a_normal_file.to_reference
		end

	Getter_functions: EVOLICITY_GETTER_FUNCTION_TABLE is
			--
		do
			Result := precursor
			Result.add (<<
				["source_path", agent get_source_path],
				["is_destination_a_normal_file", agent get_is_destination_a_normal_file],
				["destination_path", agent get_destination_path]
			>>)
		end

end

