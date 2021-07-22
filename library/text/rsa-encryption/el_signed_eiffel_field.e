note
	description: "El SIGNED EIFFEL FIELD"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-22 13:13:34 GMT (Thursday 22nd July 2021)"
	revision: "1"

class
	EL_SIGNED_EIFFEL_FIELD

inherit
	EVOLICITY_EIFFEL_CONTEXT

	EL_MODULE_BASE_64

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_value: INTEGER_X)
		local
			count_per_line, i, start_index, end_index: INTEGER
			base64_string: STRING
		do
			name := a_name
			create base_64_lines.make (4)
			base64_string := Base_64.encoded_special (a_value.as_bytes)
			count_per_line := base64_string.count // 4
			from until base_64_lines.full loop
				i := base_64_lines.count
				start_index := i * count_per_line + 1
				end_index := i * count_per_line + count_per_line
				base_64_lines.extend (base64_string.substring (start_index, end_index))
			end

			make_default
		end

feature -- Access

	name: STRING

	base_64_lines: EL_STRING_8_LIST

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["base_64_lines",	agent: ITERABLE [STRING] do Result := base_64_lines end],
				["name",				agent: STRING do Result := name end]
			>>)
		end

end