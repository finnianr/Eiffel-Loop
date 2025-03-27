note
	description: "Abstraction for file relocation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-27 10:55:42 GMT (Thursday 27th March 2025)"
	revision: "10"

deferred class
	EL_FILE_RELOCATION_COMMAND_I

inherit
	EL_DOUBLE_PATH_OPERAND_COMMAND_I
		redefine
			getter_function_table, make_default
		end

feature {NONE} -- Initialization

	make_default
		do
			timestamp_preserved := True
			Precursor
		end

feature -- Status query

	timestamp_preserved: EL_BOOLEAN_OPTION

	is_recursive: BOOLEAN
		-- True if recursive copy
		deferred
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor + ["is_recursive", agent: BOOLEAN_REF do Result := is_recursive.to_reference end]
		end

end