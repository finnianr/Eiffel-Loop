indexing
	description: "Command that takes a single path argument"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	EL_FILE_SYSTEM_OS_COMMAND [T]

feature {NONE} -- Initialization

	make (a_path: like path) is
			--
		do
			make_command
			path := a_path
		end

feature -- Access

	path: PATH_NAME

feature -- Element change

	set_path (a_path: like path) is
			--
		do
			path := a_path
		end

feature {NONE} -- Evolicity reflection

	get_path: STRING is
			--
		do
			Result := path
		end

	Getter_functions: EVOLICITY_GETTER_FUNCTION_TABLE is
			--
		do
			create Result.make (<<
				["path", agent get_path]
			>>)
		end

end

