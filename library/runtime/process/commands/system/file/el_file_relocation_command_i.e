note
	description: "Summary description for {EL_COPY_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 9:20:43 GMT (Saturday 2nd December 2017)"
	revision: "4"

deferred class
	EL_FILE_RELOCATION_COMMAND_I

inherit
	EL_DOUBLE_PATH_OPERAND_COMMAND_I
		redefine
			make_default, getter_function_table
		end

feature {NONE} -- Initialization

	make_default
		do
			is_timestamp_preserved := true
			Precursor
		end

feature -- Status query

	is_timestamp_preserved: BOOLEAN

	is_recursive: BOOLEAN
		-- True if recursive copy
		deferred
		end

feature -- Status change

	enable_timestamp_preserved
			--
		do
			is_timestamp_preserved := True
		end

	disable_timestamp_preserved
			--
		do
			is_timestamp_preserved := False
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["is_timestamp_preserved", agent: BOOLEAN_REF do Result := is_timestamp_preserved.to_reference end] +
				["is_recursive", agent: BOOLEAN_REF do Result := is_recursive.to_reference end]
		end

end
