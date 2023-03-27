note
	description: "Compare [$source EL_UNENCODED_CHARACTERS] iteration methods"
	notes: "[
		Passes over 500 millisecs (in descending order)

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-27 18:21:00 GMT (Monday 27th March 2023)"
	revision: "3"

class
	UNENCODED_CHARACTER_ITERATION_COMPARISON

obsolete
	"Replaced by EL_UNENCODED_CHARACTER_ITERATION"

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_ZSTRING_CODEC

	STRING_HANDLER

create
	make

feature -- Access

	Description: STRING = "EL_UNENCODED_CHARACTERS iteration methods"

feature -- Basic operations

	execute
		local
			russian: ZSTRING
		do
			russian := Text.lines.first
			compare ("compare iteration methods", <<
				["unencoded_characters_index",	agent unencoded_characters_index (russian)],
				["unencoded_character_iteration", agent unencoded_character_iteration (russian)]
			>>)
		end

feature {NONE} -- append_character

	unencoded_character_iteration (str: ZSTRING)
		local
			iter: EL_UNENCODED_CHARACTER_ITERATION; block_index, i, count: INTEGER
			l_area: SPECIAL [CHARACTER]; uc: CHARACTER_32; c_i: CHARACTER
			area_32: SPECIAL [CHARACTER_32]
		do
			if attached {EL_UNENCODED_CHARACTERS} str as unencoded then
				l_area := str.area; area_32 := unencoded.area
				count := str.count
				from until i = count loop
					c_i := l_area [i]
					if c_i = Substitute then
						uc := iter.item ($block_index, area_32, i + 1)
					end
					i := i + 1
				end
			end
		end

	unencoded_characters_index (str: ZSTRING)
		local
			l_area: SPECIAL [CHARACTER]; uc: CHARACTER_32; c_i: CHARACTER
			i, count: INTEGER; interval_index: UNENCODED_CHARACTERS_INDEX
		do
			if attached {EL_UNENCODED_CHARACTERS} str as unencoded then
				l_area := str.area
				interval_index := Once_unencoded_index
				interval_index.set_area (str.unencoded_area)

				count := str.count
				from until i = count loop
					c_i := l_area [i]
					if c_i = Substitute then
						uc := interval_index.item (i + 1)
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Constants

	Once_unencoded_index: UNENCODED_CHARACTERS_INDEX
		once
			create Result.make_default
		end

end