note
	description: "[
		Compare methods of iterating over [$source ZSTRING].area
	]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			inspect c (i > area_upper)     :  7723081.0 times (100%)
			inspect c (i = i_final)        :  7710823.0 times (-0.2%)
			inspect c [i] (i > area_upper) :  7681708.0 times (-0.5%)
			if c [i] = Substitute then     :   847092.0 times (-89.0%)
			if c = Substitute then         :   846940.0 times (-89.0%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-27 19:32:28 GMT (Monday 27th November 2023)"
	revision: "19"

class
	ZSTRING_AREA_ITERATION_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	HEXAGRAM_NAMES
		export
			{NONE} all
		end

	STRING_HANDLER

create
	make

feature -- Access

	Description: STRING = "{ZSTRING} methods of iterating area: SPECIAL [CHARACTER]"

feature -- Basic operations

	execute
		local
			mixed_string: ZSTRING
		do
			mixed_string := Name_manifest

			compare ("iterate over ZSTRING area", <<
				["inspect c (i = i_final)",		  agent inspect_iteration (mixed_string)],
				["inspect c (i > area_upper)",	  agent inspect_iteration_area_upper (mixed_string)],
				["inspect c [i] (i > area_upper)", agent inspect_iteration_area_upper_no_c_assign (mixed_string)],
				["if c [i] = Substitute then",	  agent if_then_iteration_no_c_assign (mixed_string)],
				["if c = Substitute then",			  agent if_then_iteration (mixed_string)]
			>>)
		end

feature {NONE} -- Operations

	if_then_iteration (mixed_string: ZSTRING)
		local
			i, i_final: INTEGER c: CHARACTER
		do
			if attached mixed_string.area as area then
				i_final := mixed_string.count
				from i := 0 until i = i_final loop
					c := area [i]
					if c = Substitute then
						do_with (c)
					elseif c.natural_32_code <= 0x7F then
						do_with (c)
					else
						do_with (c)
					end
					i := i + 1
				end
			end
		end

	if_then_iteration_no_c_assign (mixed_string: ZSTRING)
		local
			i, i_final: INTEGER
		do
			if attached mixed_string.area as c then
				i_final := mixed_string.count
				from i := 0 until i = i_final loop
					if c [i] = Substitute then
						do_with (c [i])
					elseif c [i].natural_32_code <= 0x7F then
						do_with (c [i])
					else
						do_with (c [i])
					end
					i := i + 1
				end
			end
		end

	inspect_iteration (mixed_string: ZSTRING)
		local
			i, i_final: INTEGER; c: CHARACTER
		do
			if attached mixed_string.area as area then
				i_final := mixed_string.count
				from i := 0 until i = i_final loop
					c := area [i]
					inspect c
						when Substitute then
							do_with (c)
						when Control_0 .. Control_25, Control_27 .. Max_7_bit_character then
							do_with (c)
					else
						do_with (c)
					end
					i := i + 1
				end
			end
		end

	inspect_iteration_area_upper (mixed_string: ZSTRING)
		local
			i, area_upper: INTEGER c: CHARACTER
		do
			if attached mixed_string.area as area then
				area_upper := mixed_string.count - 1
				from i := 0 until i > area_upper loop
					c := area [i]
					inspect c
						when Substitute then
							do_with (c)
						when Control_0 .. Control_25, Control_27 .. Max_7_bit_character then
							do_with (c)
					else
						do_with (c)
					end
					i := i + 1
				end
			end
		end

	inspect_iteration_area_upper_no_c_assign (mixed_string: ZSTRING)
		local
			i, area_upper: INTEGER
		do
			if attached mixed_string.area as c then
				area_upper := mixed_string.count - 1
				from i := 0 until i > area_upper loop
					inspect c [i]
						when Substitute then
							do_with (c [i])
						when Control_0 .. Control_25, Control_27 .. Max_7_bit_character then
							do_with (c [i])
					else
						do_with (c [i])
					end
					i := i + 1
				end
			end
		end


feature {NONE} -- Implementation

	do_with (c: CHARACTER)
		do
		end

end