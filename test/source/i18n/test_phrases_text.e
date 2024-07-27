note
	description: "[
		Representation of localization test data in config file: `test/data/pyxis/localization/phrases.pyx'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-25 6:59:40 GMT (Thursday 25th July 2024)"
	revision: "1"

class
	TEST_PHRASES_TEXT

inherit
	EL_REFLECTIVE_LOCALE_TEXTS

create
	make

feature -- Access

	delete_journal:ZSTRING

	enter_a_passphrase: ZSTRING

	for_n_years: ZSTRING

	new_entry: STRING
		-- test latin-1 string

feature {NONE} -- Implementation

	english_table: STRING_8
			-- description of attributes
		do
			Result := "[
				for_n_years:
					singular:
						for $QUANTITY year
					plural:
						for $QUANTITY years
				new_entry:
					&New entry\tCtrl-T
			]"
		end

end