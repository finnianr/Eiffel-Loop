note
	description: "Password security attributes accessible via [$source EL_SHARED_PASSWORD_ATTRIBUTE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-07 11:53:54 GMT (Monday 7th September 2020)"
	revision: "1"

class
	EL_PASSPHRASE_ATTRIBUTES_ENUM

inherit
	EL_DESCRIPTIVE_ENUMERATION [NATURAL_8]
		rename
			export_name as export_default,
			import_name as import_default
		end

create
	make

feature -- Access

	has_upper_case: NATURAL_8

	has_lower_case: NATURAL_8

	has_numeric: NATURAL_8

	has_symbolic: NATURAL_8

	has_at_least_8: NATURAL_8

	has_at_least_12: NATURAL_8

feature {NONE} -- Constants

	Descriptions: STRING = "[
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
