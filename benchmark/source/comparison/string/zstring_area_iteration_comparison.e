note
	description: "[
		Compare methods of iterating over [$source ZSTRING].area
	]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			inspect area [i] (i > area_upper)  :  8111750.0 times (100%)
			inspect branching (i = i_final)    :  6682035.0 times (-17.6%)
			inspect branching (i > area_upper) :  6656139.0 times (-17.9%)
			if branching                       :   859713.0 times (-89.4%)
			inspect branching (end_of_array)   :   594089.0 times (-92.7%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-22 17:20:46 GMT (Wednesday 22nd November 2023)"
	revision: "16"

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

	Description: STRING = "Compare methods of iterating over [$source ZSTRING].area"

feature -- Basic operations

	execute
		local
			mixed_string: ZSTRING
		do
			mixed_string := Name_manifest

			compare ("iterate over ZSTRING area", <<
				["inspect branching (i = i_final)",		agent inspect_iteration (mixed_string)],
				["inspect branching (i > area_upper)",	agent inspect_iteration_area_upper (mixed_string)],
				["inspect area [i] (i > area_upper)",	agent inspect_iteration_area_upper_no_c_assign (mixed_string)],
				["inspect branching (end_of_array)",	agent inspect_iteration_end_of_array (mixed_string)],
				["if branching",								agent if_then_iteration (mixed_string)]
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

	inspect_iteration (mixed_string: ZSTRING)
		local
			i, i_final: INTEGER c: CHARACTER
		do
			if attached mixed_string.area as area then
				i_final := mixed_string.count
				from i := 0 until i = i_final loop
					c := area [i]
					inspect c
						when Substitute then
							do_with (c)
						when Control_1 .. Control_25, Control_27 .. Max_7_bit_character then
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
						when Control_1 .. Control_25, Control_27 .. Max_7_bit_character then
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
			if attached mixed_string.area as area then
				area_upper := mixed_string.count - 1
				from i := 0 until i > area_upper loop
					inspect area [i]
						when Substitute then
							do_with (area [i])
						when Control_1 .. Control_25, Control_27 .. Max_7_bit_character then
							do_with (area [i])
					else
						do_with (area [i])
					end
					i := i + 1
				end
			end
		end

	inspect_iteration_end_of_array (mixed_string: ZSTRING)
		local
			i, i_final: INTEGER c: CHARACTER; end_of_array: BOOLEAN
		do
			if attached mixed_string.area as area then
				i_final := mixed_string.count
				area [i_final] := '%U'
				from i := 0 until end_of_array loop
					c := area [i]
					inspect c
						when Control_0 then
							end_of_array := True

						when Substitute then
							do_with (c)
						when Control_1 .. Control_25, Control_27 .. Max_7_bit_character then
							do_with (c)
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

	Control_0: CHARACTER = '%U'

end