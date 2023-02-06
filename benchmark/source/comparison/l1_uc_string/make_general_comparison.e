note
	description: "Compare `{L1_UC_STRING}.make_general' and `{ZSTRING}.make_general'"
	notes: "[
		Passes over 500 millisecs (in descending order)

			{L1_UC_STRING}.make_general :  53956.0 times (100%)
			{ZSTRING}.make_general      :  46847.0 times (-13.2%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-06 14:12:32 GMT (Monday 6th February 2023)"
	revision: "8"

class
	MAKE_GENERAL_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_SHARED_TEST_TEXT

create
	make

feature -- Access

	Description: STRING = "{L1_UC_STRING}.make_general vs {ZSTRING}"

feature -- Basic operations

	execute
		do
			compare ("compare make_general", <<
				["{L1_UC_STRING}.make_general", 		agent l1_uc_string_make],
				["{ZSTRING}.make_general", 			agent zstring_make]
			>>)
		end

feature {NONE} -- String append variations

	l1_uc_string_make
		local
			str: L1_UC_STRING
		do
			create str.make_from_general (Text.Russian_and_english)
		end

	zstring_make
		local
			str: ZSTRING
		do
			create str.make_from_general (Text.Russian_and_english)
		end

end