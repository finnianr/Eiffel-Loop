indexing
	description: "Summary description for {EL_COPY_FILE_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_COPY_FILE_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [EL_COPY_FILE_IMPL]
		redefine
			make, Getter_functions
		end

create
	make

feature -- {}in

	make (a_source_path, a_destination_path: like source_path)
			--
		do
			Precursor (a_source_path, a_destination_path)
			is_timestamp_preserved := true
		end

feature -- sq

	is_timestamp_preserved: BOOLEAN

feature -- ec

	set_timestamp_preserved (flag: BOOLEAN)
		do
			is_timestamp_preserved := flag
		end

feature -- {}er

	get_is_timestamp_preserved: BOOLEAN_REF
			--
		do
			Result := is_timestamp_preserved.to_reference
		end

	Getter_functions: EVOLICITY_GETTER_FUNCTION_TABLE
			--
		do
			Result := precursor
			Result.add (<<
				["is_timestamp_preserved", agent get_is_timestamp_preserved]
			>>)
		end

end

