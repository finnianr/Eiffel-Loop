note
	description: "[
		Test [$source EL_SUBSTRING_32_ARRAY] against [$source EL_ZSTRING] inheriting [$source EL_UNENCODED_CHARACTERS]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-27 10:47:33 GMT (Wednesday 27th January 2021)"
	revision: "13"

class
	SUBSTRING_32_ARRAY_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_TEST_STRINGS

	EL_ZCODE_CONVERSION undefine default_create end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		do
			eval.call ("append", agent test_append)
			eval.call ("append_substrings_into", agent test_append_substrings_into)
			eval.call ("character_count", agent test_character_count)
			eval.call ("code", agent test_code)
			eval.call ("first_interval", agent test_first_interval)
			eval.call ("hash_code", agent test_hash_code)
			eval.call ("index_of", agent test_index_of)
			eval.call ("insert", agent test_insert)
			eval.call ("occurrences", agent test_occurrences)
			eval.call ("prepend", agent test_prepend)
			eval.call ("put_code", agent test_put_code)
			eval.call ("remove", agent test_remove)
			eval.call ("remove_substring", agent test_remove_substring)
			eval.call ("shift_from", agent test_shift_from)
			eval.call ("sub_array", agent test_sub_array)
			eval.call ("substring_32_list", agent test_substring_32_list)
			eval.call ("indexable_substring_32_array_iterator", agent test_indexable_substring_32_array_iterator)
			eval.call ("to_upper", agent test_to_upper)
			eval.call ("write", agent test_write)
		end

feature -- Test

	test_append
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.append", "covers/{EL_SUBSTRING_32_ARRAY}.shifted"
		local
			word, line: ZSTRING; count: INTEGER
			array, word_array, shifted_array: EL_SUBSTRING_32_ARRAY
		do
			create line.make_empty
			array := line
			across 0 |..| 1 as n loop
				across text_russian.split (' ') as split loop
					word := split.item
					word_array := word
					shifted_array := word_array.shifted (line.count)
					if n.item = 1 and not line.is_empty then
						line.append_character (' ')
						shifted_array.shift (1)
					end
					array.append (shifted_array)
					line.append (word)
					assert ("same content", same_content (new_unencoded (line), array))
				end
			end
		end

	test_append_substrings_into
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.append_substrings_into", "covers/{EL_SUBSTRING_32_LIST}.append_interval"
		local
			zstr: ZSTRING; array, sub_array: EL_SUBSTRING_32_ARRAY; list: EL_SUBSTRING_32_LIST
			lower, upper: INTEGER
		do
			create list.make (20)
			across 1 |..| 7 as n loop
				across 1 |..| (text_russian.count - n.item + 1) as index loop
					list.wipe_out
					zstr := text_russian
					lower := index.item; upper := index.item + n.item - 1
					array := zstr
					array.append_substrings_into (list, lower, upper)
					create sub_array.make_from_area (list.to_substring_area)
					sub_array.shift ((lower - 1).opposite)
					zstr := zstr.substring (lower, upper)
					assert ("same content", same_content (new_unencoded (zstr), sub_array))
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

	test_indexable_substring_32_array_iterator
		local
			iterator: EL_INDEXABLE_SUBSTRING_32_ARRAY_ITERATOR
			text: STRING_32; list: EL_SUBSTRING_32_LIST; array: EL_SUBSTRING_32_ARRAY
			index: INTEGER; code: NATURAL
		do
			text := text_russian
			create list.make (text.count)
			across text as uc loop
				if uc.item.code > 1000 then
					list.put_character (uc.item, uc.cursor_index)
				end
			end
			create array.make_from_area (list.to_substring_area)
			create iterator.make (array)
--			forwards
			across text as uc loop
				if uc.item.code > 1000 then
					index := uc.cursor_index
					assert ("same code", uc.item.natural_32_code = iterator.code (index))
				end
			end
--			in reverse
			across text.new_cursor.reversed as uc loop
				code := uc.item.natural_32_code
				if code > 1000 then
					index := text.count - uc.cursor_index + 1
					assert ("same code", code = iterator.code (index))
				end
			end
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
					insert_array := insert
					insert_array.shift (index - 1)
					zstr.remove_substring (index, index + insert.count - 1)

					array := zstr
					array.shift_from (index, insert.count)
					array.insert (insert_array)
					zstr.insert_string (insert, index)

					assert ("same content", same_content (new_unencoded (zstr), array))
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
					word_array := word
					line_array := line
					line_array.shift (word.count)
					if n.item = 1 and not line.is_empty then
						line.prepend_character (' ')
						line_array.shift (1)
					end
					line_array.prepend (word_array)
					line.prepend (word)
					assert ("same content", same_content (new_unencoded (line), line_array))
				end
			end
		end

	test_put_code
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.put_code"
		local
			zstr: ZSTRING; index: INTEGER; array: EL_SUBSTRING_32_ARRAY
			code: NATURAL
		do
			code := ('д').natural_32_code
			across text_russian as n loop
				zstr := text_russian
				index := n.cursor_index

				array := zstr
				array.put_code (code, index)
				zstr.put_unicode (code, index)

				assert ("same content", same_content (new_unencoded (zstr), array))
			end
		end

	test_remove
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.remove"
		local
			zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY
			index: INTEGER
		do
			across text_russian as c loop
				index := c.cursor_index
				zstr := text_russian
				if c.item.natural_32_code > 1000 then
					array := zstr
					array.remove (index)
					zstr.put (' ', index)
					assert ("same content", same_content (new_unencoded (zstr), array))
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
			across 1 |..| 7 as n loop
				across 1 |..| (text_russian.count - n.item + 1) as index loop
					zstr := text_russian
					array := zstr
					lower := index.item; upper := index.item + n.item - 1
					array.remove_substring (lower, upper)
					zstr.remove_substring (lower, upper)
					assert ("same content", same_content (new_unencoded (zstr), array))
				end
			end
		end

	test_shift_from
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.shift_from"
		local
			unencoded: EL_UNENCODED_CHARACTERS; array: EL_SUBSTRING_32_ARRAY
			zstr, padded: ZSTRING; count: INTEGER
		do
			zstr := text_russian
			count := zstr.count
			across 1 |..| count as index loop
				padded := zstr + create {ZSTRING}.make_filled (' ', count)
				unencoded := new_unencoded (padded)
				array := padded
				unencoded.shift_from (index.item, count)
				create array.make_from_other (array)
				array.shift_from (index.item, count)
				assert ("same content", same_content (unencoded, array))
			end
		end

	test_sub_array
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.sub_array"
		local
			zstr, substring: ZSTRING; i, i_last, substring_count: INTEGER
			array, sub_array: EL_SUBSTRING_32_ARRAY
		do
			zstr := text_russian
			across 1 |..| 5 as n loop
				substring_count := n.item
				i_last := zstr.count - substring_count
				from i := 1 until i > i_last loop
					substring := zstr.substring (i, i + substring_count - 1)
					array := zstr
					sub_array := array.sub_array (i, i + substring_count - 1)
					sub_array.shift ((i - 1).opposite)
					assert ("same content", same_content (new_unencoded (substring), sub_array))
					i := i + 1
				end
			end
		end

	test_substring_32_list
		note
			testing: "covers/{EL_SUBSTRING_32_LIST}.put_character", "covers/{EL_SUBSTRING_32_LIST}.to_substring_area"
		local
			str_32: STRING_32; list: EL_SUBSTRING_32_LIST
			array: EL_SUBSTRING_32_ARRAY
		do
			create str_32.make (50)
			across text_lines as line loop
				str_32.wipe_out
				create list.make (line.item.count)
				across line.item as uc loop
					if uc.item.code > 127 then
						list.put_character (uc.item, uc.cursor_index)
						str_32.extend (' ')
					else
						str_32.extend (uc.item)
					end
				end
				create array.make_from_area (list.to_substring_area)
				array.write (str_32.area, 0)
				assert ("same string", line.item ~ str_32)
			end
		end

	test_to_upper
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.change_case"
		local
			zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY
		do
			zstr := text_russian
			array := zstr
			array.to_upper; zstr.to_upper
			assert ("same content", same_content (new_unencoded (zstr), array))
		end

	test_write
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.make_from_unencoded", "covers/{EL_SUBSTRING_32_ARRAY}.write"
		do
			for_each_line (agent compare_write_output)
		end

feature {NONE} -- Implementation

	compare_character_count (zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY)
		local
			unencoded: EL_UNENCODED_CHARACTERS
		do
			unencoded := new_unencoded (zstr)
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
			unencoded := new_unencoded (zstr)
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
			unencoded := new_unencoded (zstr)
			assert ("same hash_code", unencoded.hash_code (50) = array.hash_code (50))
		end

	compare_index_of (zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY)
		local
			i: INTEGER; unencoded: EL_UNENCODED_CHARACTERS; uc: NATURAL
		do
			unencoded := new_unencoded (zstr)
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
			unencoded := new_unencoded (zstr)
			from i := 1 until i > zstr.count loop
				if zstr.z_code (i) > 0xFF then
					uc := zstr.unicode (i)
					assert ("same occurrences", array.occurrences (uc) = unencoded.occurrences (uc))
				end
				i := i + 1
			end
		end

	compare_write_output (zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY)
		do
			assert ("same content", same_content (new_unencoded (zstr), array))
		end

	for_each_line (test: PROCEDURE [ZSTRING, EL_SUBSTRING_32_ARRAY])
		local
			zstr: ZSTRING; array: EL_SUBSTRING_32_ARRAY
		do
			across Text_lines as line loop
				zstr := line.item
				array := zstr
				test (zstr, array)
			end
		end

	new_unencoded (zstr: ZSTRING): EL_UNENCODED_CHARACTERS
		require
			implemented: False
		do
--			Result := zstr
		end

	same_content (unencoded: EL_UNENCODED_CHARACTERS; array: EL_SUBSTRING_32_ARRAY): BOOLEAN
		local
			output_1, output_2: STRING_32
		do
			if array.not_empty then
				if array.first_lower = unencoded.first_lower and then array.last_upper = unencoded.last_upper then
					create output_1.make_filled (' ', unencoded.last_upper)
					unencoded.write (output_1.area, 0)

					create output_2.make_filled (' ', array.last_upper)
					array.write (output_2.area, 0)
					Result := output_1 ~ output_2
				end
			else
				Result := not unencoded.not_empty
			end
		end

end
