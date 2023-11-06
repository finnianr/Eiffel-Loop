note
	description: "Test class [$source L1_UC_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 16:41:41 GMT (Monday 6th November 2023)"
	revision: "15"

class
	STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO; EL_MODULE_REUSEABLE

	EL_SHARED_TEST_TEXT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["expanded_string",					 agent test_expanded_string],
				["immutable_comparison",			 agent test_immutable_comparison],
				["reusable_zstrings",				 agent test_reusable_zstrings],
				["string_pool",						 agent test_string_pool],
				["string_pool_loan_list",			 agent test_string_pool_loan_list],
				["l1_uc_string_conversion",		 agent test_l1_uc_string_conversion],
				["l1_uc_string_unicode_by_index", agent test_l1_uc_string_unicode_by_index]
			>>)
		end

feature -- Tests

	test_expanded_string
		-- TEXT_DATA_TEST_SET.test_expanded_string
		local
			ex: EXPANDED_STRING; s: STRING
		do
			s := "abc"
			ex.share (s)
			assert ("same hash_code", ex.hash_code = 6382179)
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
			across Reuseable.string as reuse loop
				s1 := reuse.item
				assert ("empty string", s1.is_empty)
				s1.append_string_general ("abc")
				across Reuseable.string as reuse2 loop
					s3 := reuse2.item
					assert ("s3 is new instance", s1 /= s3)
				end
			end
			across Reuseable.string as reuse loop
				s2 := reuse.item
				assert ("empty string", s2.is_empty)
				across Reuseable.string as reuse2 loop
					s4 := reuse2.item
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
							pool.return_list (loan_indices)
							assert ("returned available", pool.available_count = old_count + loan_indices.capacity)
						end
					end
					old_count := pool.available_count
					old_indices_count := loan_indices.count
					assert ("valid indices", loan_indices.for_all (agent pool.valid_index))
					pool.return_list (loan_indices)
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