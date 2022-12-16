note
	description: "String list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-16 16:33:09 GMT (Friday 16th December 2022)"
	revision: "24"

class
	SPLIT_STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_STRING_8_CONSTANTS

	EL_ENCODING_CONSTANTS

	EL_MODULE_LIO

	EL_MODULE_TUPLE

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("fill_tuple", agent test_fill_tuple)
			eval.call ("occurrence_intervals", agent test_occurrence_intervals)
			eval.call ("path_split", agent test_path_split)
			eval.call ("set_encoding_from_name", agent test_set_encoding_from_name)
			eval.call ("skip_empty_split", agent test_skip_empty_split)
			eval.call ("split_and_join_1", agent test_split_and_join_1)
			eval.call ("split_and_join_2", agent test_split_and_join_2)
			eval.call ("split_and_join_3", agent test_split_and_join_3)
			eval.call ("split_iterator", agent test_split_iterator)
			eval.call ("split_sort", agent test_split_sort)
			eval.call ("split_string_8", agent test_split_string_8)
		end

feature -- Tests

	test_fill_tuple
		local
			t1: TUPLE [animal: STRING; letter: CHARACTER; weight: DOUBLE; age: INTEGER]
			t2: TUPLE [currency: STRING; symbol: STRING_32]
		do
			create t1
			Tuple.fill (t1, "cat, C, 6.5, 4")
			assert ("cat", t1.animal ~ "cat")
			assert ("C", t1.letter = 'C')
			assert ("6.5 kg", t1.weight = 6.5)
			assert ("4 years", t1.age = 4)

			create t2
			tuple.fill (t2, {STRING_32} "euro, €")
			assert ("same currency", t2.currency ~ "euro")
			lio.put_string_field ("SYMBOL " + t2.symbol.generator, t2.symbol)
			lio.put_new_line
			assert ("same symbol", t2.symbol ~ {STRING_32} "€")
		end

	test_occurrence_intervals
		local
			intervals: EL_OCCURRENCE_INTERVALS [STRING]
			str: STRING; item_lower, item_upper: INTEGER
		do
			create intervals.make_by_string (Api_string_list.joined_with_string (Comma_space), Comma_space)
			create str.make (Api_string.count)
			across Api_string_list as api loop
				if not str.is_empty then
					item_lower := str.count + 1
					str.append (Comma_space)
					item_upper := str.count
					intervals.go_i_th (api.cursor_index - 1)
					assert ("same item_lower", item_lower = intervals.item_lower)
					assert ("same item_upper", item_upper = intervals.item_upper)
				end
				str.append (api.item)
			end
		end

	test_path_split
		local
			list: LIST [STRING]; split_8_path: EL_SPLIT_STRING_LIST [STRING]
			split_path: EL_SPLIT_ZSTRING_LIST; l_path: STRING
		do
			list := Unix_path.split ('/')
			l_path := Unix_path.twin
			across 1 |..| 2 as n loop
				create split_path.make_by_string (l_path, "/")
				across list as step loop
					assert ("same step", step.item ~ split_path.i_th (step.cursor_index).to_string_8)
				end

				create split_8_path.make_by_string (l_path, "/")
				across list as step loop
					assert ("same step", step.item ~ split_path.i_th (step.cursor_index))
				end
				l_path.append_character ('/')
			end
		end

	test_set_encoding_from_name
		note
			testing: "covers/{EL_ITERABLE_SPLIT_CURSOR}.forth, covers/{EL_ITERABLE_SPLIT_CURSOR}.item"
		local
			encodeable: EL_ENCODEABLE_AS_TEXT; name: STRING
		do
			create encodeable.make_default
			across << False, True >> as is_lower_case loop
				across ("ISO-8859-1,UTF-8,WINDOWS-1252").split (',') as split loop
					name := split.item
					if is_lower_case.item then
						name.to_lower
					end
					encodeable.set_encoding_from_name (name)
					inspect split.cursor_index
						when 1 then
							assert ("is ISO-8859-1", encodeable.encoded_as_latin (1))
						when 2 then
							assert ("UTF-8", encodeable.encoded_as_utf (8))
						when 3 then
							assert ("WINDOWS-1252", encodeable.encoded_as_windows (1252))
					else
					end
					assert ("same upper name", name.as_upper ~ encodeable.encoding_name)
				end
			end
		end

	test_skip_empty_split
		note
			testing: "covers/{EL_SPLIT_ON_CHARACTER}.new_cursor"
		local
			character_split: EL_SPLIT_ON_CHARACTER [STRING]
			split_list: EL_STRING_8_LIST
		do
			create character_split.make (",a,b,c,", ',')
			create split_list.make_empty
			across character_split as split loop
				if not split.item_is_empty then
					split_list.extend (split.item_copy)
				end
			end
			assert ("same_list", same_list (split_list, "a,b,c"))
		end

	test_split_and_join_1
		local
			list: EL_STRING_LIST [STRING]
		do
			create list.make_split (Numbers, ',')
			assert ("same string", Numbers ~ list.joined (','))

			list := << "one", "two", "three" >>
			assert ("same string", Numbers ~ list.joined (','))
		end

	test_split_and_join_2
		local
			list: EL_SPLIT_ZSTRING_LIST
		do
			create list.make_by_string (Numbers, ",")
			assert ("same string", Numbers ~ list.joined (','))
		end

	test_split_and_join_3
		local
			list: EL_SPLIT_STRING_32_LIST
		do
			create list.make_adjusted (Sales, ',', {EL_STRING_ADJUST}.Left)
			from list.start until list.after loop
				lio.put_string_field (list.index.out, list.item)
				lio.put_new_line
				list.forth
			end
			assert ("same string", Sales ~ list.joined_with_string (", "))
		end

	test_split_iterator
		note
			testing: "covers/{EL_ITERABLE_SPLIT_CURSOR}.forth, covers/{EL_ITERABLE_SPLIT_CURSOR}.item,%
						%covers/{EL_ITERABLE_SPLIT_CURSOR}.item_is_empty,%
						%covers/{EL_ITERABLE_SPLIT_CURSOR}.item_copy,%
						%covers/{EL_ITERABLE_SPLIT_CURSOR}.item_same_as,%
						%covers/{EL_ITERABLE_SPLIT_CURSOR}.item_same_caseless_as"
		local
			string_split: EL_SPLIT_ON_STRING [STRING]; character_split: EL_SPLIT_ON_CHARACTER [STRING]
			splitter_array: ARRAY [EL_ITERABLE_SPLIT [STRING, ANY]]
			split_list: EL_STRING_8_LIST; str_list, bracket_pair, first_item: STRING
			adjustments: INTEGER
		do
			bracket_pair := "()"
			across Comma_separated_variations as csv_list loop
				if csv_list.item.has (' ') then
					adjustments := {EL_STRING_ADJUST}.Both
				else
					adjustments := 0
				end
				create character_split.make_adjusted (csv_list.item, ',', adjustments)

				str_list := csv_list.item.twin
				str_list.replace_substring_all (",", bracket_pair)
				create string_split.make_adjusted (str_list, bracket_pair, adjustments)

				splitter_array := << string_split, character_split >>
				across splitter_array as splitter loop
					create split_list.make (5)
					across splitter.item as split loop
						if split.cursor_index = 1 then
							first_item := split.item
						else
							assert ("same string instance", first_item = split.item)
						end
						if not split.item_is_empty and then split.item [1] = 'a' then
							assert ("same as a", split.item_same_as ("a"))
							assert ("same as A", split.item_same_caseless_as ("A"))
						end
						split_list.extend (split.item_copy)
					end
					assert ("same_list", same_list (split_list, csv_list.item))
				end
			end
		end

	test_split_sort
		local
			split: EL_SPLIT_STRING_LIST [STRING]
			list: EL_STRING_8_LIST
		do
			create split.make_by_string ("ZAB, ZAC, ZAC1, ZA, CAL, CON, CAT, CAN, CANOPY", Comma_space)
			create list.make (split.count)
			across split as animal loop
				list.extend (animal.item_copy)
			end
			list.sort
			split.sort (True)
			across list as animal loop
				assert ("same animal", animal.item ~ split.i_th (animal.cursor_index))
			end
		end

	test_split_string_8
		note
			testing: "covers/{EL_SPLIT_STRING_LIST}.make", "covers/{EL_FILLED_STRING_8_TABLE}.item"
		local
			list: EL_SPLIT_STRING_LIST [STRING]; str_split: LIST [STRING]
		do
			across Comma_separated_variations as csv_list loop
				create list.make_adjusted (csv_list.item, ',', {EL_STRING_ADJUST}.Left)
				str_split := csv_list.item.split (',')
				from list.start until list.after loop
					str_split.go_i_th (list.index)
					str_split.item.left_adjust
					assert ("same_item_as", list.item_same_as (str_split.item))
					assert ("equal items", list.item ~ str_split.item)
					list.forth
				end
			end
		end

feature {NONE} -- Implementation

	same_list (split_list: EL_STRING_8_LIST; str: STRING): BOOLEAN
		do
			if attached str.split (',') as str_split and then str_split.count = split_list.count then
				str_split.do_all (agent {STRING}.adjust)
				Result := across str_split as split all split.item ~ split_list [split.cursor_index]  end
			end
		end

feature {NONE} -- Constants

	Api_string: STRING = "[
		DTA1-HMAC-SHA256 SignedHeaders=content-length;content-type;host;x-amz-date
		Credential=PUBLIC/20200124
		Signature=B7387390DEC2CD5A515B67EE50D220A3EE4507DC2F71EA67F59BDB0DE9FF403B
	]"

	Api_string_list: EL_STRING_8_LIST
		once
			create Result.make_with_lines (Api_string)
		end

	Comma_separated_variations: ARRAY [STRING]
		once
			Result := << ",a,b,c,", "a,b,c", " a, b , c ", "" >>
		end

	Numbers: STRING = "one,two,three"

	Sales: STRING_32 = "widget, €10, in stock"

	Unix_path: STRING = "/home/joe"
end