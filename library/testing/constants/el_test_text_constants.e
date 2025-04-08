note
	description: "Constants related to ${EL_TEST_TEXT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 13:03:16 GMT (Tuesday 8th April 2025)"
	revision: "1"

deferred class
	EL_TEST_TEXT_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Eiffel

	Eiffel_assignment: STRING = "[
		str := "1%N2%"/3"
	]"

	Eiffel_type_declarations: STRING = "[
		STRING
		ARRAY [STRING]
		HASH_TABLE [STRING, STRING]
		ARRAY [HASH_TABLE [STRING, STRING]]
		HASH_TABLE [ARRAY [HASH_TABLE [STRING, STRING]], STRING]
	]"

feature {NONE} -- Line constants

	Line_cyrillic: INTEGER = 1

	Line_ascii: INTEGER = 2

	Line_accented: INTEGER = 3

	Line_latin_1: INTEGER = 4

	Line_latin_15: INTEGER = 5

	Line_quattro: INTEGER = 6

	Line_euro: INTEGER = 7

feature {NONE} -- STRING_32 contants

	Lower_case_characters: STRING_32 = "™ÿaàöžšœ" --

	Lower_case_mu: STRING_32 = "µ symbol"

	Upper_case_characters: STRING_32 = "™ŸAÀÖŽŠŒ"

	Upper_case_mu: STRING_32 = "Μ SYMBOL"

	Escaped_substitution_marker: STRING = "%%%S"

end