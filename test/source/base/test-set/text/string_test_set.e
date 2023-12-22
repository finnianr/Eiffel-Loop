note
	description: "Test class [$source L1_UC_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-22 14:43:24 GMT (Friday 22nd December 2023)"
	revision: "22"

class
	STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO; EL_MODULE_XML

	EL_SHARED_TEST_TEXT; EL_SHARED_ZSTRING_BUFFER_SCOPES; EL_SHARED_FORMAT_FACTORY

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["c_utf_string_8",					 agent test_c_utf_string_8],
				["bracketed",							 agent test_bracketed],
				["expanded_string",					 agent test_expanded_string],
				["format_double",						 agent test_format_double],
				["format_integer",					 agent test_format_integer],
				["immutable_comparison",			 agent test_immutable_comparison],
				["reusable_zstrings",				 agent test_reusable_zstrings],
				["string_pool",						 agent test_string_pool],
				["string_pool_loan_list",			 agent test_string_pool_loan_list],
				["l1_uc_string_conversion",		 agent test_l1_uc_string_conversion],
				["l1_uc_string_unicode_by_index", agent test_l1_uc_string_unicode_by_index]
			>>)
		end

feature -- Tests

	test_bracketed
		-- STRING_TEST_SET.test_bracketed
		local
			s: EL_STRING_8_ROUTINES; name: STRING
		do
			name := "cat"
			assert_same_string (Void, s.bracketed (XML.open_tag (name), '<'), name)
		end

	test_c_utf_string_8
		 -- STRING_TEST_SET.test_c_utf_string_8
		note
			testing: "[
				covers/{EL_C_UTF_STRING_8}.make_from_utf_8,
				covers/{EL_C_UTF_STRING_8}.fill_string,
				covers/{EL_UC_ROUTINES}.encoded_byte_count,
				covers/{EL_UC_ROUTINES}.encoded_first_value,
				covers/{EL_UC_ROUTINES}.encoded_next_value
			]"
		local
			c_str: EL_C_UTF_STRING_8; str_32: STRING_32; zstr: ZSTRING
		do
			create str_32.make_empty
			across Text.lines as line loop
				zstr := line.item
				create c_str.make_from_utf_8 (zstr.to_utf_8)
				str_32.wipe_out
				c_str.fill_string (str_32)
				assert_same_string (Void, str_32, zstr)
			end
		end

	test_expanded_string
		-- TEXT_DATA_TEST_SET.test_expanded_string
		local
			ex: EXPANDED_STRING; s: STRING
		do
			s := "abc"
			ex.share (s)
			assert ("same hash_code", ex.hash_code = 6382179)
		end

	test_format_double
		-- STRING_TEST_SET.test_format_double
		note
			testing: "[
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_left_until,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_left_character,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_left_until,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_right_until,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_right_character,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_right_until,
				covers/{EL_FORMAT_DOUBLE}.make
			]"
		local
			double, format_5_2: EL_FORMAT_DOUBLE; pi: DOUBLE
			format_table: EL_HASH_TABLE [STRING, STRING]
		do
			create format_5_2.make ("999.99")
			assert ("rounded and no justification", format_5_2.formatted (10.519) ~ "10.52")

			pi := {MATH_CONST}.Pi
			create format_table.make (<<
				["99.99",	 "3.14"],		-- width = 5, decimals = 2, no justification by default
				["99,99",	 "3,14"],		-- decimal point is a comma
				["99.99%%",	 "3.14%%"],	-- percentile
				["99.99|",	 " 3.14"],		-- right justified
				["|99.99",	 "3.14 "],		-- left justified
				["|999.99|", " 3.14 "], -- centered and width = 6
				["|99.99%%", "3.14%% "] -- left justified percentile
			>>)
			double := "99.99"
			assert_same_string (Void, double.formatted (pi * 100), "314.16")

			across format_table as table loop
				double := table.key
				if double.formatted (pi) /~ table.item then
					lio.put_string_field (table.key, table.item)
					lio.put_new_line
					lio.put_double_field ("formatted", pi, table.key)
					lio.put_new_line
					assert ("same as formatted", False)
				end
			end
		end

	test_format_integer
		-- STRING_TEST_SET.test_format_integer
		note
			testing: "[
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_left_until,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_left_character,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_left_until,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_right_until,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_right_character,
				covers/{EL_SIMPLE_IMMUTABLE_PARSER_8}.try_remove_right_until,
				covers/{EL_FORMAT_DOUBLE}.make
			]"
		local
			integer: EL_FORMAT_INTEGER; format_table: EL_HASH_TABLE [STRING, STRING]
			n: INTEGER
		do
			n := 64
			create format_table.make (<<
				["999",	  " 64"],		-- width = 3, right justified by default
				["|999",	  "64 "],		-- left justified
				["999|",	  " 64"],		-- right justified
				["999|",	  " 64"],		-- right justified
				["0999|",  "064"],		-- left justified with zero padding
				["|9999|", " 64 "],	-- centered
				["999%%|", " 64%%"],	-- percentile
				["|999%%", "64%% "] 	-- left justified percentile
			>>)
			across format_table as table loop
				integer := table.key
				if integer.formatted (n) /~ table.item then
					lio.put_string_field (table.key, table.item)
					lio.put_new_line
					lio.put_string_field ("formatted", integer.formatted (n))
					lio.put_new_line
					assert ("same as formatted", False)
				end
			end
		end

	test_immutable_comparison
		-- STRING_TEST_SET.test_immutable_comparison
		-- found bug in `SPECIAL.same_items' affecting `{IMMUTABLE_STRING_8}.same_string'
		local
			csv, foreground, background: IMMUTABLE_STRING_8; comma_index: INTEGER
			s8: EL_STRING_8_ROUTINES; foreground_2: STRING
		do
			create csv.make_from_string ("foreground, background")
			comma_index := csv.index_of (',', 1)
			foreground := csv.shared_substring (1, comma_index - 1)
			background := csv.shared_substring (comma_index + 2, csv.count)

--			assert ("bug in SPECIAL.same_items", foreground.same_string (background))
			assert ("strings differ", not s8.same_strings (foreground, background))

			assert ("strings are the same", s8.same_strings (background, background.to_string_8))
		end

	test_reusable_zstrings
		-- STRING_TEST_SET.test_reusable_zstrings
		local
			s1, s2, s3, s4: ZSTRING
		do
			across String_scope as scope loop
				s1 := scope.item
				assert ("empty string", s1.is_empty)
				s1.append_string_general ("abc")
				across String_scope as scope_inner loop
					s3 := scope_inner.item
					assert ("s3 is new instance", s1 /= s3)
				end
			end
			across String_scope as scope loop
				s2 := scope.item
				assert ("empty string", s2.is_empty)
				across String_scope as scope_inner loop
					s4 := scope_inner.item
				end
			end
			assert ("instance recycled", s1 = s2)
			assert ("nested instances recycled", s3 = s4)
		end

	test_string_pool
		-- STRING_TEST_SET.test_string_pool
		local
			pool: EL_STRING_POOL [STRING_32]; buffer: ARRAYED_LIST [STRING_32]
			pool_item: STRING_32; old_count: INTEGER; line_list: EL_STRING_32_LIST
		do
			line_list := Text.lines

			across 0 |..| 1 as ascending loop
				across 1 |..| 5 as capacity loop
					create pool.make (line_list.count)
					create buffer.make (capacity.item)
					line_list.sort (ascending.item.to_boolean)
					across line_list as list loop
						if attached list.item as str then
							pool_item := pool.borrowed_item (str.count)
							assert ("is empty", pool_item.is_empty)
							pool_item.append (str)
							buffer.extend (pool_item)
						end
						if buffer.full then
							old_count := pool.available_count
							across buffer as string loop
								pool.return (string.item)
							end
							buffer.wipe_out
							assert ("returned available", pool.available_count = old_count + buffer.capacity)
						end
					end
					old_count := pool.available_count
					across buffer as string loop
						pool.return (string.item)
					end
					assert ("all returned", pool.available_count = old_count + buffer.count)
				end
			end
		end

	test_string_pool_loan_list
		-- STRING_TEST_SET.test_string_pool_loan_list
		local
			pool: EL_STRING_POOL [STRING_32]; loan_indices: ARRAYED_LIST [INTEGER]
			pool_item: STRING_32; old_count, old_indices_count: INTEGER; line_list: EL_STRING_32_LIST
		do
			line_list := Text.lines

			across 0 |..| 1 as ascending loop
				across 1 |..| 5 as capacity loop
					create pool.make (line_list.count)
					create loan_indices.make (capacity.item)
					line_list.sort (ascending.item.to_boolean)
					across line_list as list loop
						if attached list.item as str then
							pool_item := pool.borrowed_item (str.count)
							assert ("is empty", pool_item.is_empty)
							pool_item.append (str)
							loan_indices.extend (pool.last_index)
						end
						if loan_indices.full then
							old_count := pool.available_count
							pool.free_list (loan_indices)
							assert ("returned available", pool.available_count = old_count + loan_indices.capacity)
						end
					end
					old_count := pool.available_count
					old_indices_count := loan_indices.count
					assert ("valid indices", loan_indices.for_all (agent pool.valid_index))
					pool.free_list (loan_indices)
					assert ("loan_indices empty", loan_indices.is_empty)
					assert ("all returned", pool.available_count = old_count + old_indices_count)
				end
			end
		end

feature -- L1_UC_STRING tests

	test_l1_uc_string_conversion
		note
			testing: "covers/{SUBSTRING_32_ARRAY}.write, covers/{SUBSTRING_32_LIST}.append_character"
		local
			l1_uc: L1_UC_STRING; code: NATURAL
		do
			create l1_uc.make_from_general (Text.Russian_and_english)
			assert ("strings equal", Text.Russian_and_english ~ l1_uc.to_string_32)
		end

	test_l1_uc_string_unicode_by_index
		note
			testing: "covers/{SUBSTRING_32_ARRAY}.code_item, covers/{SUBSTRING_32_LIST}.append_character"
		local
			l1_uc: L1_UC_STRING; code: NATURAL
		do
			create l1_uc.make_from_general (Text.Russian_and_english)

--			Test binary search in `code_item'
			across Text.Russian_and_english as char loop
				code := char.item.natural_32_code
				if code > 0xFF then
					assert ("same code", code = l1_uc.unicode (char.cursor_index))
				end
			end
		end

feature {NONE} -- Constants

	Padded_euro: ZSTRING
		once

		end
end