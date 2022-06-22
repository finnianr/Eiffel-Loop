note
	description: "Summary description for {EL_COPY_FILE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 14:47:12 GMT (Thursday 24th December 2015)"
	revision: "1"

class
	EL_COPY_FILE_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [EL_COPY_FILE_IMPL]
		redefine
			make, getter_function_table
		end

create
	make, make_default

feature {NONE} -- Initialization

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