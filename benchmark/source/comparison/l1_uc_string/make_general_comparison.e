note
	description: "Compare `{L1_UC_STRING}.make_general' and `{ZSTRING}.make_general'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 9:23:54 GMT (Saturday 29th October 2022)"
	revision: "5"

class
	MAKE_GENERAL_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_SHARED_TEST_TEXT

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
			create str.make_from_general (Text.Russian_and_english)
		end

	zstring_make
		local
			str: ZSTRING
		do
			create str.make_from_general (Text.Russian_and_english)
		end

end