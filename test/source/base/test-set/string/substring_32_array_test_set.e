note
	description: "Test [$source EL_UNENCODED_CHARACTERS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-24 14:42:27 GMT (Sunday 24th January 2021)"
	revision: "10"

class
	SUBSTRING_32_ARRAY_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_TEST_STRINGS

	EL_ZCODE_CONVERSION undefine default_create end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		do
--			eval.call ("append", agent test_append)
--			eval.call ("character_count", agent test_character_count)
--			eval.call ("code", agent test_code)
--			eval.call ("first_interval", agent test_first_interval)
--			eval.call ("hash_code", agent test_hash_code)
--			eval.call ("index_of", agent test_index_of)
--			eval.call ("insert", agent test_insert)
--			eval.call ("occurrences", agent test_occurrences)
--			eval.call ("prepend", agent test_prepend)
			eval.call ("remove_substring", agent test_remove_substring)
--			eval.call ("shift_from", agent test_shift_from)
--			eval.call ("sub_array", agent test_sub_array)
--			eval.call ("write", agent test_write)
		end

feature -- Test

	test_append
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.append", "covers/{EL_SUBSTRING_32_ARRAY}.shifted"
		local
			word, line: ZSTRING; count: INTEGER
			unencoded: EL_UNENCODED_CHARACTERS; array, word_array, shifted_array: EL_SUBSTRING_32_ARRAY
		do
			create line.make_empty
			create array.make_from_unencoded (line)
			across 0 |..| 1 as n loop
				across text_russian.split (' ') as split loop
					word := split.item
					create word_array.make_from_unencoded (word)
					shifted_array := word_array.shifted (line.count)
					if n.item = 1 and not line.is_empty then
						line.append_character (' ')
						shifted_array.shift (1)
					end
					array.append (shifted_array)
					line.append (word)
					unencoded := line
					assert ("same content", same_content (unencoded, array, line.count))
				end
			end
		end

	test_character_count
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.character_count", "covers/{EL_SUBSTRING_32_ARRAY}.utf_8_byte_count"
		do
			for_each_line (agent compare_character_count)
		end

	test_code
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.code"
		do
			for_each_line (agent compare_codes)
		end

	test_first_interval
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.first_lower", "covers/{EL_SUBSTRING_32_ARRAY}.first_upper"
		do
			for_each_line (agent compare_first_interval)
		end

	test_hash_code
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.hash_code"
		do
			for_each_line (agent compare_hash_code)
		end

	test_index_of
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.index_of", "covers/{EL_SUBSTRING_32_ARRAY}.last_index_of"
		do
			for_each_line (agent compare_index_of)
		end

	test_insert
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.insert"
		local
			insert, zstr: ZSTRING; index: INTEGER
			insert_array, array: EL_SUBSTRING_32_ARRAY
		do
			across 1 |..| 2 as count loop
				create insert.make_filled ('д', count.item)
				across 1 |..| (text_russian.count - 1) as n loop
					zstr := text_russian
					index := n.item
					create insert_array.make_from_unencoded (insert)
					insert_array.shift (index - 1)
					zstr.remove_substring (index, index + insert.count - 1)

					create array.make_from_unencoded (zstr)
					array.shift_from (index, insert.count)
					array.insert (insert_array)
					zstr.insert_string (insert, index)

					assert ("same content", same_content (zstr, array, zstr.count))
				end
			end
		end

	test_occurrences
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.occurrences"
		do
			for_each_line (agent compare_occurrences)
		end

	test_prepend
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.prepend", "covers/{EL_SUBSTRING_32_ARRAY}.shifted"
		local
			word, line: ZSTRING; count: INTEGER
			word_array, line_array: EL_SUBSTRING_32_ARRAY
		do
			create line.make_empty
			across 0 |..| 1 as n loop
				across text_russian.split (' ') as split loop
					word := split.item
					create word_array.make_from_unencoded (word)
					create line_array.make_from_unencoded (line)
					line_array.shift (word.count)
					if n.item = 1 and not line.is_empty then
						line.prepend_character (' ')
						line_array.shift (1)
					end
					line_array.prepend (word_array)
					line.prepend (word)
					assert ("same content", same_content (line, line_array, line.count))
				end
			end
		end

	test_remove_substring
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.remove_substring"
		local
			zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY
			lower, upper: INTEGER
		do
			across 1 |..| 5 as n loop
				across 1 |..| (text_russian.count - n.item + 1) as index loop
					zstr := text_russian
					create array.make_from_unencoded (zstr)
					lower := index.item; upper := index.item + n.item - 1
					array.remove_substring (lower, upper)
					zstr.remove_substring (lower, upper)
					assert ("same content", same_content (zstr, array, zstr.count))
				end
			end
		end

	test_shift_from
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.shift_from"
		local
			zstr: ZSTRING; count: INTEGER
			unencoded: EL_UNENCODED_CHARACTERS; array: EL_SUBSTRING_32_ARRAY
		do
			zstr := text_russian
			count := zstr.count
			across 1 |..| count as index loop
				unencoded := zstr + create {ZSTRING}.make_filled (' ', count)
				create array.make_from_unencoded (unencoded)
				unencoded.shift_from (index.item, count)
				create array.make_from_other (array)
				array.shift_from (index.item, count)
				assert ("same content", same_content (unencoded, array, count * 2))
			end
		end

	test_sub_array
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.sub_array"
		local
			zstr, substring: ZSTRING; i, i_last, substring_count: INTEGER
			unencoded: EL_UNENCODED_CHARACTERS; array, sub_array: EL_SUBSTRING_32_ARRAY
		do
			zstr := text_russian
			across 1 |..| 5 as n loop
				substring_count := n.item
				i_last := zstr.count - substring_count
				from i := 1 until i > i_last loop
					substring := zstr.substring (i, i + substring_count - 1)
					create array.make_from_unencoded (zstr)
					sub_array := array.sub_array (i, i + substring_count - 1)
					sub_array.shift ((i - 1).opposite)
					assert ("same content", same_content (substring, sub_array, substring_count))
					i := i + 1
				end
			end
		end

	test_write
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.make_from_unencoded", "covers/{EL_SUBSTRING_32_ARRAY}.write"
		do
			for_each_line_2 (agent compare_write_output)
		end

feature {NONE} -- Implementation

	compare_character_count (zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY)
		local
			unencoded: EL_UNENCODED_CHARACTERS
		do
			unencoded := zstr
			assert ("same character_count", unencoded.character_count = array.character_count)
			assert ("same utf_8_byte_count", unencoded.utf_8_byte_count = array.utf_8_byte_count)
		end

	compare_codes (zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY)
		local
			i: INTEGER
		do
			from i := 1 until i > zstr.count loop
				if zstr.z_code (i) > 0xFF then
					assert ("same code", array.code (i) = zstr.unicode (i))
				end
				i := i + 1
			end
		end

	compare_first_interval (zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY)
		local
			unencoded: EL_UNENCODED_CHARACTERS
		do
			unencoded := zstr
			if array.not_empty then
				assert ("same first_lower", unencoded.first_lower = array.first_lower)
				assert ("same first_upper", unencoded.first_upper = array.first_upper)
			else
				assert ("empty unencoded", unencoded.area.count = 0)
			end
		end

	compare_hash_code (zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY)
		local
			unencoded: EL_UNENCODED_CHARACTERS
		do
			unencoded := zstr
			assert ("same hash_code", unencoded.hash_code (50) = array.hash_code (50))
		end

	compare_index_of (zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY)
		local
			i: INTEGER; unencoded: EL_UNENCODED_CHARACTERS; uc: NATURAL
		do
			unencoded := zstr
			from i := 1 until i > zstr.count loop
				if zstr.z_code (i) > 0xFF then
					uc := zstr.unicode (i)
					assert ("same index_of", array.index_of (uc, 1) = unencoded.index_of (uc, 1))
					assert ("same last_index_of", array.last_index_of (uc, zstr.count) = unencoded.last_index_of (uc, zstr.count))
				end
				i := i + 1
			end
		end

	compare_occurrences (zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY)
		local
			i: INTEGER; unencoded: EL_UNENCODED_CHARACTERS; uc: NATURAL
		do
			unencoded := zstr
			from i := 1 until i > zstr.count loop
				if zstr.z_code (i) > 0xFF then
					uc := zstr.unicode (i)
					assert ("same occurrences", array.occurrences (uc) = unencoded.occurrences (uc))
				end
				i := i + 1
			end
		end

	compare_write_output (zstr: ZSTRING; l1: L1_ZSTRING)
		do
			assert ("to_string_32 equal", zstr.to_string_32 ~ l1.to_string_32)
		end

	for_each_line (test: PROCEDURE [ZSTRING, EL_SUBSTRING_32_ARRAY])
		local
			zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY
		do
			across Text_lines as line loop
				zstr := line.item
				create array.make_from_unencoded (zstr)
				test (zstr, array)
			end
		end

	for_each_line_2 (test: PROCEDURE [ZSTRING, L1_ZSTRING])
		local
			zstr: ZSTRING; l1: L1_ZSTRING
		do
			across text_lines as line loop
				zstr := line.item
				l1 := line.item
				test (zstr, L1)
			end
		end

	same_content (unencoded: EL_UNENCODED_CHARACTERS; array: EL_SUBSTRING_32_ARRAY; count: INTEGER): BOOLEAN
		local
			output_1, output_2: STRING_32
		do
			if array.count.to_boolean then
				create output_1.make_filled (' ', count)
				unencoded.write (output_1.area, 0)

				create output_2.make_filled (' ', count)
				array.write (output_2.area, 0)
				Result := output_1 ~ output_2
			else
				Result := unencoded.area.count = 0
			end
		end

end