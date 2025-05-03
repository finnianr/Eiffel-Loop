note
	description: "Compare methods of counting number of unencoded characters"
	notes: "[
		3 May 2025

		Passes over 500 millisecs (in descending order)

			count substitute occurrences   :  7825957.0 times (100%)
			call unencoded_character_count :   237235.0 times (-97.0%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-03 13:17:24 GMT (Saturday 3rd May 2025)"
	revision: "1"

class
	ZSTRING_UNENCODED_COUNT_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON
		rename
			Character_type as Character_abstract_type
		end

	HEXAGRAM_NAMES_I

	EL_SHARED_ZSTRING_CODEC

create
	make

feature -- Access

	Description: STRING = "ZSTRING: count number of unencoded characters"

feature -- Basic operations

	execute
		local
			str: ZSTRING
		do
			str := Name_manifest
			compare ("count number of unencoded characters", <<
				["count substitute occurrences",	  agent count_substitute_occurrences (str)],
				["call unencoded_character_count", agent unencoded_character_count (str)]
			>>)
		end

feature {NONE} -- Operations

	count_substitute_occurrences (str: ZSTRING)
		local
			i, count, i_upper: INTEGER
		do
			if attached str.area as c then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
					inspect c [i]
						when Substitute then
							count := count + 1
					else
					end
					i := i + 1
				end
			end
		end

	unencoded_character_count (unencoded: EL_COMPACT_SUBSTRINGS_32_I)
		local
			count: INTEGER
		do
			count := unencoded.character_count
		end

end