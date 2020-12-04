note
	description: "String benchmark comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-04 13:31:54 GMT (Friday 4th December 2020)"
	revision: "3"

deferred class
	STRING_BENCHMARK_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

feature {NONE} -- Constants

	Chinese: ARRAY [STRING_32]
		once
			Result := << {STRING_32} "(屯)", {STRING_32} "(乾)" >>
		end

	Hexagram_1_description: STRING_32 = "Hex. #1 - Qián (屯) - The Creative, Creating, Pure Yang, Inspiring Force, Dragon"

end