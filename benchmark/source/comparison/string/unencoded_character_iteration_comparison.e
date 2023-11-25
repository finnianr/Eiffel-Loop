note
	description: "Compare [$source EL_UNENCODED_CHARACTERS] iteration methods"
	notes: "[
		Passes over 500 millisecs (in descending order)

			UNENCODED_CHARACTER_ITERATION_EXTERNAL :  3980.0 times (100%)
			EL_UNENCODED_CHARACTER_ITERATION       :  3974.0 times (-0.2%)
			UNENCODED_CHARACTERS_INDEX             :  3356.0 times (-15.7%)

		**Conclusion**

		Using external C routine to get/set integer from pointer is only marginally faster (0.2%) than using
		[$source POINTER] routines.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-25 9:46:20 GMT (Saturday 25th November 2023)"
	revision: "4"

class
	UNENCODED_CHARACTER_ITERATION_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_ZSTRING_CODEC

	STRING_HANDLER

create
	make

feature -- Access

	Description: STRING = "{EL_UNENCODED_CHARACTERS}.area iteration methods"

feature -- Basic operations

	execute
		local
			russian: ZSTRING
		do
			russian := Text.lines.first
			compare ("Iterate over ZSTRING characters", <<
				["EL_UNENCODED_CHARACTER_ITERATION",		 agent unencoded_character_iteration (russian)],
				["UNENCODED_CHARACTERS_INDEX",				 agent unencoded_characters_index (russian)],
				["UNENCODED_CHARACTER_ITERATION_EXTERNAL", agent external_pointer_get_set (russian)]
			>>)
		end

feature {NONE} -- append_character

	external_pointer_get_set (str: ZSTRING)
		local
			iter: UNENCODED_CHARACTER_ITERATION_EXTERNAL; block_index, i, count: INTEGER
			l_area: SPECIAL [CHARACTER]; uc: CHARACTER_32; c_i: CHARACTER
			area_32: SPECIAL [CHARACTER_32]
		do
			across 1 |..| 1000 as n loop
				if attached {EL_UNENCODED_CHARACTERS} str as unencoded then
					l_area := str.area; area_32 := unencoded.area
					count := str.count
					from until i = count loop
						inspect l_area [i]
							when Substitute then
								uc := iter.item ($block_index, area_32, i + 1)
						else
						end
						i := i + 1
					end
				end
			end
		end

	unencoded_character_iteration (str: ZSTRING)
		local
			iter: EL_UNENCODED_CHARACTER_ITERATION; block_index, i, count: INTEGER
			l_area: SPECIAL [CHARACTER]; uc: CHARACTER_32; c_i: CHARACTER
			area_32: SPECIAL [CHARACTER_32]
		do
			across 1 |..| 1000 as n loop
				if attached {EL_UNENCODED_CHARACTERS} str as unencoded then
					l_area := str.area; area_32 := unencoded.area
					count := str.count
					from until i = count loop
						inspect l_area [i]
							when Substitute then
								uc := iter.item ($block_index, area_32, i + 1)
						else
						end
						i := i + 1
					end
				end
			end
		end

	unencoded_characters_index (str: ZSTRING)
		local
			l_area: SPECIAL [CHARACTER]; uc: CHARACTER_32; c_i: CHARACTER
			i, count: INTEGER; interval_index: UNENCODED_CHARACTERS_INDEX
		do
			across 1 |..| 1000 as n loop
				if attached {EL_UNENCODED_CHARACTERS} str as unencoded then
					l_area := str.area
					interval_index := Once_unencoded_index
					interval_index.set_area (str.unencoded_area)

					count := str.count
					from until i = count loop
						inspect l_area [i]
							when Substitute then
								uc := interval_index.item (i + 1)
						else
						end
						i := i + 1
					end
				end
			end
		end

feature {NONE} -- Constants

	Once_unencoded_index: UNENCODED_CHARACTERS_INDEX
		once
			create Result.make_default
		end

end