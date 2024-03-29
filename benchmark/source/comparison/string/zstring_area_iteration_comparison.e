note
	description: "[
		Compare methods of iterating over ${ZSTRING}.area
	]"
	notes: "[
		Passes over 2000 millisecs (in descending order)

			inspect c (i > area_upper)     :  7951779.0 times (100%)
			inspect c [i] (i > area_upper) :  7943184.0 times (-0.1%)
			inspect c (i = i_final)        :  7809947.0 times (-1.8%)
			if c = Substitute then         :   857938.0 times (-89.2%)
			inspect c.code |>> 7           :   857684.0 times (-89.2%)
			inspect c.code // 0x80         :   855976.0 times (-89.2%)
			if c [i] = Substitute then     :   853939.0 times (-89.3%)
			inspect type [c.code]          :   405349.0 times (-94.9%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "26"

class
	ZSTRING_AREA_ITERATION_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	HEXAGRAM_NAMES
		export
			{NONE} all
		end

create
	make

feature -- Access

	Description: STRING = "ZSTRING: methods of iterating area: SPECIAL [CHARACTER]"

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
				["inspect type [c.code]",			  agent inspect_character_type (mixed_string)],
				["inspect c.code // 0x80",		  agent inspect_code_div_0x100 (mixed_string)],
				["inspect c.code |>> 7",			  agent inspect_7_bit_ascii_shift (mixed_string)],
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

	inspect_7_bit_ascii_shift (mixed_string: ZSTRING)
		local
			i, i_final: INTEGER; c: CHARACTER
		do
			if attached mixed_string.area as area then
				i_final := mixed_string.count
				from i := 0 until i = i_final loop
					c := area [i]
					inspect c.code |>> 7 -- remove ASCII bits
						when 0 then
						-- is ASCII
							inspect c
								when Substitute then
									do_with (c)
							else
								do_with (c)
							end
					else
						do_with (c)
					end
					i := i + 1
				end
			end
		end

	inspect_character_type (mixed_string: ZSTRING)
		local
			i, area_upper: INTEGER c: CHARACTER
		do
			if attached mixed_string.area as area
				and then attached Character_type as type
			then
				area_upper := mixed_string.count - 1
				from i := 0 until i > area_upper loop
					c := area [i]
					inspect Character_type [c.code]
						when Type_unencoded then
							do_with (c)
						when Type_ascii then
							do_with (c)
					else
						do_with (c)
					end
					i := i + 1
				end
			end
		end

	inspect_code_div_0x100 (mixed_string: ZSTRING)
		local
			i, area_upper: INTEGER c: CHARACTER
		do
			if attached mixed_string.area as area then
				area_upper := mixed_string.count - 1
				from i := 0 until i > area_upper loop
					c := area [i]
					inspect c.code // 0x80 -- Zero if in 7-bit ASCII range
						when 0 then
							inspect c
								when Substitute then
									do_with (c)
							else
								do_with (c)
							end
					else
						do_with (c)
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
						when Control_0 .. Control_25, Control_27 .. Max_ascii then
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
						when Control_0 .. Control_25, Control_27 .. Max_ascii then
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
						when Control_0 .. Control_25, Control_27 .. Max_ascii then
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

feature {NONE} -- Constants

	Character_type: SPECIAL [NATURAL_8]
		local
			i: INTEGER
		once
			create Result.make_filled (0, 0x100)
			from i := 0 until i > 0x7F loop
				Result [i] := Type_ascii
				i := i + 1
			end
			Result [26] := Type_unencoded
		end

	Type_ascii: NATURAL_8 = 1

	Type_unencoded: NATURAL_8 = 2
end