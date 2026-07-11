note
	description: "[
		Benchmark some typical string operations for ${STRING_8} and an equivalent C orientated string class
		using a managed C buffer `area' instead of a ${SPECIAL [CHARACTER]} `area'.
	]"
	notes: "[
		**BENCHMARKING RESULTS**

		Passes over 1000 millisecs (each in descending order)
		
		RESULTS: indexed_item

			C buffer indexed_item   :  788.0 times (100%)
			C buffer indexed_string :  782.0 times (-0.8%)
			SPECIAL indexed_item    :  780.0 times (-1.0%)

		RESULTS: starts_with

			C buffer starts_with : 2178.0 times (100%)
			SPECIAL starts_with  :  878.0 times (-59.7%)

		RESULTS: occurrences

			C buffer occurrences : 2170.0 times (100%)
			SPECIAL occurrences  : 1687.0 times (-22.3%)

		RESULTS: CSV line parsing

			C buffer parse_csv :  65.0 times (100%)
			SPECIAL parse_csv  :  52.0 times (-20.0%)

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-06-01 10:28:47 GMT (Monday 1st June 2026)"
	revision: "3"

class
	STRING_8_VS_C_STRING_8

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "STRING_8 VS C_STRING_8 basic routines"

feature -- Basic operations

	execute
		local
			cache: C_NULLED_STRING_8_NAME_CACHE
		do
			if attached new_string_list as string_list and then attached new_c_string_list as c_string_list then
				compare ("indexed_item", <<
					["SPECIAL indexed_item",  agent special_indexed_item (string_list)],
					["C buffer indexed_item", agent c_buffer_indexed_item (c_string_list)],
					["C buffer indexed_string", agent c_buffer_indexed_string (c_string_list)]
				>>)
				compare ("starts_with", <<
					["SPECIAL starts_with",	 agent special_starts_with (string_list, The)],
					["C buffer starts_with", agent c_buffer_starts_with (c_string_list, C_the)]
				>>)
				compare ("occurrences", <<
					["SPECIAL occurrences",	 agent special_occurrences (string_list, 'a')],
					["C buffer occurrences", agent c_buffer_occurrences (c_string_list, 'a')]
				>>)
				compare ("CSV line parsing", <<
					["SPECIAL parse_csv",  agent special_parse_csv (string_list)],
					["C buffer parse_csv", agent c_buffer_parse_csv (c_string_list)]
				>>)
			end
		end

feature {NONE} -- Benchmark occurrences

	c_buffer_occurrences (title_list: LIST [C_STRING_8]; c: CHARACTER_8)
		local
			count: INTEGER
		do
			across 0 |..| 100 as n loop
				across title_list as list loop
					count := count + list.item.occurrences (c)
				end
			end
		end

	special_occurrences (title_list: LIST [STRING_8]; c: CHARACTER_8)
		local
			count: INTEGER
		do
			across 0 |..| 100 as n loop
				across title_list as list loop
					count := count + list.item.occurrences (c)
				end
			end
		end

feature {NONE} -- Compare indexed item		

	c_buffer_indexed_item (title_list: LIST [C_STRING_8])
		local
			count, i, i_final: INTEGER; area: POINTER
		do
			across 0 |..| 100 as n loop
				across title_list as list loop
					area := list.item.area
					from i := 1; i_final := list.item.count until i = i_final loop
						if char_at (area, i) = 'a' then
							count := count + 1
						end
						i := i + 1
					end
				end
			end
		end

	c_buffer_indexed_string (title_list: LIST [C_STRING_8])
		local
			count, i, i_final: INTEGER
		do
			across 0 |..| 100 as n loop
				across title_list as list loop
					if attached list.item as str then
						from i := 1; i_final := list.item.count until i > i_final loop
							if str [i] = 'a' then
								count := count + 1
							end
							i := i + 1
						end
					end
				end
			end
		end

	special_indexed_item (title_list: LIST [STRING_8])
		local
			count, i, i_final: INTEGER; area: SPECIAL [CHARACTER]
		do
			across 0 |..| 100 as n loop
				across title_list as list loop
					area := list.item.area
					from i := 0; i_final := list.item.count until i = i_final loop
						if area [i] = 'a' then
							count := count + 1
						end
						i := i + 1
					end
				end
			end
		end


feature {NONE} -- Compare parse CSV

	c_buffer_parse_csv (title_list: LIST [C_STRING_8])
		local
			count: INTEGER
		do
			across 0 |..| 100 as n loop
				across title_list as list loop
					count := count + new_c_string_csv_list (list.item).count
				end
			end
		end

	special_parse_csv (title_list: LIST [STRING_8])
		local
			count: INTEGER
		do
			across 0 |..| 100 as n loop
				across title_list as list loop
					count := count + new_csv_list (list.item).count
				end
			end
		end


feature {NONE} -- Compare starts_with

	c_buffer_starts_with (title_list: LIST [C_STRING_8]; str: C_STRING_8)
		local
			count: INTEGER
		do
			across 0 |..| 100 as n loop
				across title_list as list loop
					if list.item.starts_with (str) then
						count := count + 1
					end
				end
			end
		end

	special_starts_with (title_list: LIST [STRING_8]; str: STRING_8)
		local
			count: INTEGER
		do
			across 0 |..| 100 as n loop
				across title_list as list loop
					if list.item.starts_with (str) then
						count := count + 1
					end
				end
			end
		end

feature {NONE} -- Contract Support

	new_split_list (str: STRING_8; c: CHARACTER_8): LIST [STRING_8]
		-- allow object comparison on splits
		do
			Result := str.split (c)
			Result.compare_objects
		end

feature {NONE} -- List factory

	new_c_string_csv_list (str: C_STRING_8): ARRAYED_LIST [C_STRING_8]
		local
			prev_i, next_i: INTEGER
		do
			create Result.make (str.occurrences (',') + 1)
			Result.compare_objects
			from until Result.full loop
				next_i := str.index_of (',', prev_i + 1)
				if next_i = 0 then
					next_i := str.count + 1
				end
				Result.extend (str.substring (prev_i + 1, next_i - 1))
				prev_i := next_i
			end
		ensure
			same_as_split:
				across new_split_list (str.to_string, ',') as list all
					list.item ~ Result [list.cursor_index].to_string
				end
		end

	new_c_string_list: ARRAYED_LIST [C_STRING_8]
		do
			if attached new_string_list as string_list then
				create Result.make (string_list.count)
				across string_list as list loop
					Result.extend (list.item)
				end
			end
		ensure
			same_as_new_string_list:
				across new_string_list as list all
					Result [list.cursor_index].is_equal (list.item)
				end
		end

	new_csv_list (str: STRING_8): ARRAYED_LIST [STRING_8]
		local
			prev_i, next_i: INTEGER
		do
			create Result.make (str.occurrences (',') + 1)
			Result.compare_objects
			from until Result.full loop
				next_i := str.index_of (',', prev_i + 1)
				if next_i = 0 then
					next_i := str.count + 1
				end
				Result.extend (str.substring (prev_i + 1, next_i - 1))
				prev_i := next_i
			end
		ensure
			same_as_split: Result ~ new_split_list (str, ',')
		end

	new_string_list: ARRAYED_LIST [STRING_8]
		do
			create Result.make_from_array (Hexagram.English_titles.to_array)
		end

feature {NONE} -- Implementation

	frozen char_at (a_area: POINTER; i: INTEGER): CHARACTER_8
			-- Character at offset `i' in buffer `a_area'.
		external
			"C inline"
		alias
			"return ((EIF_CHARACTER_8 *)$a_area)[$i];"
		end

feature {NONE} -- Constants

	C_the: C_STRING_8
		once
			Result := The.string
		ensure
			same_string: Result.to_string ~ The
		end

	The: STRING_8
		once
			Result := "The"
		end
end
