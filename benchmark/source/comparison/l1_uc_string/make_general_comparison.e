note
	description: "Compare `{L1_UC_STRING}.make_general' and `{ZSTRING}.make_general'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-08 9:05:58 GMT (Thursday 8th April 2021)"
	revision: "4"

class
	MAKE_GENERAL_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_TEST_STRINGS

create
	make

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
			create str.make_from_general (Text_russian_and_english)
		end

	zstring_make
		local
			str: ZSTRING
		do
			create str.make_from_general (Text_russian_and_english)
		end


end