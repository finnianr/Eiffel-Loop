note
	description: "Signed Eiffel field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:15:22 GMT (Sunday 22nd September 2024)"
	revision: "5"

class
	EL_SIGNED_EIFFEL_FIELD

inherit
	EVOLICITY_EIFFEL_CONTEXT

	EL_MODULE_BASE_64

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_value: INTEGER_X)
		do
			name := a_name; data_lines := new_data_lines (a_value)
			make_default
		end

feature -- Access

	data_lines: EL_STRING_8_LIST

	name: STRING

feature {NONE} -- Implementation

	new_data_lines (a_value: INTEGER_X): EL_STRING_8_LIST
		local
			count_per_line, i, start_index, end_index: INTEGER
			base64_string: STRING
		do
			create Result.make (4)
			base64_string := Base_64.encoded_special (a_value.as_bytes, False)
			count_per_line := base64_string.count // 4
			from until Result.full loop
				i := Result.count
				start_index := i * count_per_line + 1
				end_index := i * count_per_line + count_per_line
				Result.extend (base64_string.substring (start_index, end_index))
			end

		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["data_lines",	agent: ITERABLE [STRING] do Result := data_lines end],
				["name",			agent: STRING do Result := name end]
			>>)
		end

end