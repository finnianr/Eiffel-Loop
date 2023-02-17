note
	description: "String benchmark comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-17 10:42:09 GMT (Friday 17th February 2023)"
	revision: "6"

deferred class
	STRING_BENCHMARK_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

	EL_SHARED_TEST_TEXT

	SHARED_HEXAGRAM_STRINGS

feature {NONE} -- Constants

	Chinese: ARRAY [STRING_32]
		once
			Result := << {STRING_32} "(屯)", {STRING_32} "(乾)" >>
		end

	Hexagram_1_description: STRING_32 = "[
		Hex. #1 - Qián (屯) - The Creative, Creating, Pure Yang, Inspiring Force, Dragon
	]"

end