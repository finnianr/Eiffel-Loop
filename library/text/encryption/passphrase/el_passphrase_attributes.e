note
	description: "Password security attributes for use in class ${EL_PASSPHRASE_EVALUATOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-25 7:17:20 GMT (Thursday 25th July 2024)"
	revision: "8"

class
	EL_PASSPHRASE_ATTRIBUTES

inherit
	EL_REFLECTIVE_LOCALE_TEXTS

create
	make

feature -- Values

	has_at_least_12: ZSTRING

	has_at_least_8: ZSTRING

	has_lower_case: ZSTRING

	has_numeric: ZSTRING

	has_symbolic: ZSTRING

	has_upper_case: ZSTRING

feature {NONE} -- Implementation

	english_table: STRING
		do
			Result := "[
				has_upper_case:
					Contains an upper-case character
				has_lower_case:
					Contains a lower-case character
				has_numeric:
					Contains a numeric character
				has_symbolic:
					Contains a symbolic character ([]:&*^%# etc)
				has_at_least_8:
					Contains at least 8 characters
				has_at_least_12:
					Contains at least 12 characters
			]"
		end

end