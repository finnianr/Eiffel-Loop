note
	description: "Compare methods of iterating over ${ZSTRING}.area"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-03 12:09:25 GMT (Saturday 3rd May 2025)"
	revision: "31"

class
	ZSTRING_AREA_ITERATION_COMPARISON

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

	Description: STRING = "ZSTRING: inspecting each area [i]"

feature -- Basic operations

	execute
		local
			mixed_string, ascii_string: ZSTRING; title: STRING
		do
			mixed_string := Name_manifest
			ascii_string := Hexagram.English_titles.joined_lines

			across << ascii_string, mixed_string >> as list loop
				if attached list.item as str then
					title := if str = mixed_string then "mixed encoding" else "ASCII" end
					compare ("iterate over " + title + " area", <<
						["if c [i] = Substitute",				 agent if_c_i_eq_substitute_then (str)],
						["if c = Substitute",					 agent if_c_eq_substitute_then (str)],
						["if in_latin_1_disjoint_set (c_i)", agent if_c_i_in_latin_1_disjoint_set (str)],
						["inspect c when Substitute",			 agent inspect_c_when_substitute (str)],
						["inspect c [i]",							 agent inspect_c_i_when_substitute (str)],
						["inspect character_8_band (c)",		 agent inspect_character_8_band (str)],
						["inspect type [c.code]",				 agent inspect_character_type (str)],
						["inspect c.code // 0x80",				 agent inspect_code_div_0x100 (str)],
						["inspect c.code |>> 7",				 agent inspect_7_bit_ascii_shift (str)]
					>>)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Operations

	if_c_eq_substitute_then (str: ZSTRING)
		local
			i, i_upper: INTEGER c: CHARACTER
		do
			if attached str.area as area then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
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

	if_c_i_eq_substitute_then (str: ZSTRING)
		local
			i, i_upper: INTEGER
		do
			if attached str.area as c then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
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

	if_c_i_in_latin_1_disjoint_set (str: ZSTRING)
		local
			i, i_upper: INTEGER; c_i: CHARACTER
		do
			if attached str.area as area and then attached codec as l_codec then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
					c_i := area [i]
					if l_codec.in_latin_1_disjoint_set (c_i) then
						inspect c_i
							when Substitute then
								do_with (c_i)
						else
							do_with (c_i)
						end
					else
						do_with (c_i)
					end
					i := i + 1
				end
			end
		end

	inspect_7_bit_ascii_shift (str: ZSTRING)
		local
			i, i_upper: INTEGER; c: CHARACTER
		do
			if attached str.area as area then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
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

	inspect_c_i_when_substitute (str: ZSTRING)
		local
			i, i_upper: INTEGER
		do
			if attached str.area as c then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
					inspect character_8_band (c [i])
						when Substitute then
							do_with (c [i])

						when Ascii_range then
							do_with (c [i])
					else
						do_with (c [i])
					end
					i := i + 1
				end
			end
		end

	inspect_c_when_substitute (str: ZSTRING)
		local
			i, i_upper: INTEGER; c: CHARACTER
		do
			if attached str.area as area then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
					c := area [i]
					inspect c
						when Substitute then
							do_with (c)

						when Ascii_range then
							do_with (c)
					else
						do_with (c)
					end
					i := i + 1
				end
			end
		end

	inspect_character_8_band (str: ZSTRING)
		local
			i, i_upper: INTEGER; c: CHARACTER
		do
			if attached str.area as area then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
					c := area [i]
					inspect character_8_band (c)
						when Substitute then
							do_with (c)
						when Ascii_range then
							do_with (c)
					else
						do_with (c)
					end
					i := i + 1
				end
			end
		end

	inspect_character_type (str: ZSTRING)
		local
			i, i_upper: INTEGER c: CHARACTER
		do
			if attached str.area as area and then attached Character_type as type then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
					c := area [i]
					inspect type [c.code]
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

	inspect_code_div_0x100 (str: ZSTRING)
		local
			i, i_upper: INTEGER c: CHARACTER
		do
			if attached str.area as area then
				i_upper := str.count - 1
				from i := 0 until i > i_upper loop
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

note
	notes: "[
		3 May 2025

		RESULTS: iterate over ASCII area
		Passes over 500 millisecs (in descending order)

			inspect c when Substitute        :  8068414.0 times (100%)
			inspect character_8_band (c)     :  8062034.0 times (-0.1%)
			inspect type [c.code]            :  7810362.0 times (-3.2%)
			inspect c [i]                    :  6115444.0 times (-24.2%)
			inspect c.code // 0x80           :   193083.0 times (-97.6%)
			if c = Substitute                :   191878.0 times (-97.6%)
			inspect c.code |>> 7             :   191539.0 times (-97.6%)
			if c [i] = Substitute            :   188331.0 times (-97.7%)
			if in_latin_1_disjoint_set (c_i) :     5529.0 times (-99.9%)

		RESULTS: iterate over mixed encoding area
		Passes over 500 millisecs (in descending order)

			inspect c when Substitute        :  8081291.0 times (100%)
			inspect character_8_band (c)     :  8028977.0 times (-0.6%)
			inspect type [c.code]            :  7749464.0 times (-4.1%)
			inspect c [i]                    :  6100308.0 times (-24.5%)
			inspect c.code // 0x80           :   855946.0 times (-89.4%)
			inspect c.code |>> 7             :   840006.0 times (-89.6%)
			if c [i] = Substitute            :   839339.0 times (-89.6%)
			if c = Substitute                :   830392.0 times (-89.7%)
			if in_latin_1_disjoint_set (c_i) :    25117.0 times (-99.7%)

	]"
end