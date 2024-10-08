note
	description: "Compare ${L1_UC_STRING}.unicode and ${ZSTRING}.unicode"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "15"

class
	UNICODE_ITEM_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "L1_UC_STRING.unicode"

feature -- Basic operations

	execute
		local
			l1: L1_UC_STRING; zstr: ZSTRING
		do
			create l1.make_from_general (Text.Mixed_text)
			create zstr.make_from_general (Text.Mixed_text)

			compare ("compare unicode", <<
				["L1_UC_STRING.unicode", agent l1_uc_string_unicode (l1)],
				["ZSTRING.unicode", 		 agent zstring_unicode (zstr)]
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