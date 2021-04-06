note
	description: "Compare `{L1_UC_STRING}.unicode' and `{ZSTRING}.unicode'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-06 9:39:13 GMT (Tuesday 6th April 2021)"
	revision: "2"

class
	UNICODE_ITEM_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_TEST_STRINGS

create
	make

feature -- Basic operations

	execute
		local
			l1: L1_UC_STRING; zstr: ZSTRING
		do
			create l1.make_from_general (Text_russian_and_english)
			create zstr.make_from_general (Text_russian_and_english)

			compare ("compare unicode", 1000, <<
				["{L1_UC_STRING}.unicode", 	agent l1_uc_string_unicode (l1)],
				["{ZSTRING}.unicode", 			agent zstring_unicode (zstr)]
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