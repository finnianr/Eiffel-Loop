note
	description: "Compare `{L1_UC_STRING}.unicode' and `{ZSTRING}.unicode'"
	notes: "[
		Passes over 500 millisecs (in descending order)

			{ZSTRING}.unicode      :  37917.0 times (100%)
			{L1_UC_STRING}.unicode :  29418.0 times (-22.4%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-06 14:13:15 GMT (Monday 6th February 2023)"
	revision: "8"

class
	UNICODE_ITEM_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_SHARED_TEST_TEXT

create
	make

feature -- Access

	Description: STRING = "{L1_UC_STRING}.unicode"

feature -- Basic operations

	execute
		local
			l1: L1_UC_STRING; zstr: ZSTRING
		do
			create l1.make_from_general (Text.Russian_and_english)
			create zstr.make_from_general (Text.Russian_and_english)

			compare ("compare unicode", <<
				["{L1_UC_STRING}.unicode", agent l1_uc_string_unicode (l1)],
				["{ZSTRING}.unicode", 		agent zstring_unicode (zstr)]
			>>)
		end

feature {NONE} -- String append variations

	l1_uc_string_unicode (str: L1_UC_STRING)
		local
			i: INTEGER; code: NATURAL
		do
			from i := 1 until i > str.count loop
				code := str.unicode (i)
				i := i + 1
			end
		end

	zstring_unicode (str: ZSTRING)
		local
			i: INTEGER; code: NATURAL
		do
			from i := 1 until i > str.count loop
				code := str.unicode (i)
				i := i + 1
			end
		end


end