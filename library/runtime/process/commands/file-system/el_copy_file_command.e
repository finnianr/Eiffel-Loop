note
	description: "Summary description for {EL_COPY_FILE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-05 12:36:20 GMT (Tuesday 5th November 2013)"
	revision: "3"

class
	EL_COPY_FILE_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [EL_COPY_FILE_IMPL]
		redefine
			make, default_create, getter_function_table
		end

create
	make, default_create

feature {NONE} -- Initialization

	default_create
		do
			make_command
		end

	make (a_source_path, a_destination_path: like source_path)
			--
		do
			Precursor (a_source_path, a_destination_path)
			is_timestamp_preserved := true
		end

feature -- Status query

	is_timestamp_preserved: BOOLEAN

	is_recursive: BOOLEAN
		-- True if recursive copy
		do
			Result := False
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

	get_is_timestamp_preserved: BOOLEAN_REF
			--
		do
			Result := is_timestamp_preserved.to_reference
		end

	get_is_recursive: BOOLEAN_REF
			--
		do
			Result := is_recursive.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			Result := precursor
			Result.append_tuples (<<
				["is_timestamp_preserved", agent get_is_timestamp_preserved],
				["is_recursive", agent get_is_recursive]
			>>)
		end

end
