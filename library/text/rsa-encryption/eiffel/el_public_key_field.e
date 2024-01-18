note
	description: "Obfuscates an ${INTEGER_X} into an array of factorized numbers"
	notes: "[
		Example
		
			<< 2*100, 5*13, 3*1, 3*31, 241, 3*5 .. >>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_PUBLIC_KEY_FIELD

inherit
	EL_SIGNED_EIFFEL_FIELD
		redefine
			new_data_lines
		end

	SINGLE_MATH

create
	make

feature {NONE} -- Implementation

	append_factorized (str: STRING; n: INTEGER)
		local
			factor: INTEGER
		do
			from factor := 2 until n \\ factor = 0 or factor > sqrt (n).rounded loop
				factor := factor + 1
			end
			if factor < n and then n \\ factor = 0 then
				str.append_integer (factor)
				str.append_character ('*')
				str.append_integer (n // factor)
			else
				str.append_integer (n)
			end
		end

	new_data_lines (a_value: INTEGER_X): EL_STRING_8_LIST
			-- Intended to create a manifest format that is more difficult to tamper with at machine code level
			-- Anti-piracy measure
		local
			count_per_line, i: INTEGER; bytes: SPECIAL [NATURAL_8]
			line: STRING
		do
			bytes := a_value.as_bytes
			create Result.make (bytes.upper + 1)
			count_per_line := 18
			from i := 0 until i > bytes.upper loop
				if i \\ count_per_line = 0 then
					create line.make (100)
					Result.extend (line)
				end
				append_factorized (line, bytes [i])
				i := i + 1
				if i >= 1 and i <= bytes.upper then
					line.append_string (", ")
				end
			end
		end

end