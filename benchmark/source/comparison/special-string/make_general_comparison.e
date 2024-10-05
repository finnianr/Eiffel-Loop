note
	description: "Compare ${L1_UC_STRING}.make_general and ${ZSTRING}.make_general"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "15"

class
	MAKE_GENERAL_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "L1_UC_STRING.make_general vs ZSTRING"

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
			create str.make_from_general (Text.Mixed_text)
		end

	zstring_make
		local
			str: ZSTRING
		do
			create str.make_from_general (Text.Mixed_text)
		end

end