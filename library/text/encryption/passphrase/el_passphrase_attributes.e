note
	description: "Password security attributes for use in class ${EL_PASSPHRASE_EVALUATOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "7"

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

feature {NONE} -- Constants

	English_table: STRING = "[
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