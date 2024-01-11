note
	description: "[
		Test [$source EL_SUBSTRING_32_ARRAY] against [$source EL_COMPACT_SUBSTRINGS_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-11 14:27:06 GMT (Thursday 11th January 2024)"
	revision: "29"

class
	SUBSTRING_32_ARRAY_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_ZCODE_CONVERSION undefine default_create end

	EL_SHARED_TEST_TEXT

create
	make

feature {NONE} -- Initialization

	make
		do
			make_named (<<
				["append", agent test_append],
				["append_substring", agent test_append_substring],
				["character_count", agent test_character_count],
				["code", agent test_code],
				["first_interval", agent test_first_interval],
				["hash_code", agent test_hash_code],
				["index_of", agent test_index_of],
				["insert", agent test_insert],
				["occurrences", agent test_occurrences],
				["prepend", agent test_prepend],
				["put_code", agent test_put_code],
				["remove", agent test_remove],
				["remove_substring", agent test_remove_substring],
				["shift_from", agent test_shift_from],
				["sub_array", agent test_sub_array],
				["substring_32_list", agent test_substring_32_list],
				["zstring_indexable", agent test_zstring_indexable],
				["to_upper", agent test_to_upper],
				["write", agent test_write]
			>>)
		end

feature -- Test

	test_append
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.append", "covers/{EL_SUBSTRING_32_ARRAY}.shifted"
		local
			word, line: ZSTRING; count: INTEGER
			unencoded: EL_COMPACT_SUBSTRINGS_32; array, word_array, shifted_array: EL_SUBSTRING_32_ARRAY
		do
			create line.make_empty
			create array.make_from_unencoded (line)
			across 0 |..| 1 as n loop
				across Text.russian.split (' ') as split loop
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
					assert ("same content", same_content (array, unencoded))
				end
			end
		end

	test_append_substring
		note
			testing: "covers/{EL_COMPACT_SUBSTRINGS_32_BUFFER}.append_substring"
		local
			zstr: ZSTRING; unencoded, sub_unencoded: EL_COMPACT_SUBSTRINGS_32
			extendable: EL_COMPACT_SUBSTRINGS_32_BUFFER; lower, upper: INTEGER
		do
			create extendable.make
			across 1 |..| 7 as n loop
				across 1 |..| (Text.russian.count - n.item + 1) as index loop
					extendable.wipe_out
					zstr := Text.russian
					lower := index.item; upper := index.item + n.item - 1
					unencoded := zstr
					extendable.append_substring (unencoded, lower, upper, 0)
					create sub_unencoded.make_from_other (extendable)
					zstr := zstr.substring (lower, upper)
					assert ("same content", same_content (zstr, sub_unencoded))
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

	test_zstring_indexable
		local
			unencoded: EL_INDEXABLE_SUBSTRING_32_ARRAY
			str_32: STRING_32; list: EL_SUBSTRING_32_LIST; array: EL_SUBSTRING_32_ARRAY
			index: INTEGER; code: NATURAL
		do
			str_32 := Text.russian
			create list.make (str_32.count)
			across str_32 as uc loop
				if uc.item.code > 1000 then
					list.put_character (uc.item, uc.cursor_index)
				end
			end
			create array.make_from_area (list.to_substring_area)
			create unencoded.make (array)
--			forwards
			across str_32 as uc loop
				if uc.item.code > 1000 then
					index := uc.cursor_index
					assert ("same code", uc.item.natural_32_code = unencoded.code (index))
				end
			end
--			in reverse
			across str_32.new_cursor.reversed as uc loop
				code := uc.item.natural_32_code
				if code > 1000 then
					index := str_32.count - uc.cursor_index + 1
					assert ("same code", code = unencoded.code (index))
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
			zstr := Text.russian
			index := zstr.index_of (',', 1)
			insert := {STRING_32} "не"

			create insert_array.make_from_unencoded (insert)
			insert_array.shift (index - 1)
			create array.make_from_unencoded (zstr)
			array.insert (insert_array)

			zstr.replace_substring (insert, index, index + 1)
			assert ("same content", same_content (array, zstr))
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
			word_unencoded, line_unencoded: EL_COMPACT_SUBSTRINGS_32
		do
			create line.make_empty
			across 0 |..| 1 as n loop
				across Text.russian.split (' ') as split loop
					word := split.item
					word_unencoded := word
					line_unencoded := line
					line_unencoded.shift (word.count)
					if n.item = 1 and not line.is_empty then
						line.prepend_character (' ')
						line_unencoded.shift (1)
					end
					line_unencoded.insert (word_unencoded)
					assert ("same content", same_content (line, line_unencoded))
				end
			end
		end

	test_put_code
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.put"
		local
			zstr: ZSTRING; index: INTEGER; unencoded: EL_COMPACT_SUBSTRINGS_32
			uc: CHARACTER_32
		do
			uc := 'д'
			across Text.russian as n loop
				zstr := Text.russian
				index := n.cursor_index

				unencoded := zstr
				unencoded.put (uc, index)
				zstr.put (uc, index)

				assert ("same content", same_content (zstr, unencoded))
			end
		end

	test_remove
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.remove"
		local
			zstr: ZSTRING; unencoded: EL_COMPACT_SUBSTRINGS_32
			index: INTEGER
		do
			across Text.russian as c loop
				index := c.cursor_index
				zstr := Text.russian
				if c.item.natural_32_code > 1000 then
					unencoded := zstr
					unencoded.remove (index)
					zstr.put (' ', index)
					assert ("same content", same_content (zstr, unencoded))
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
				across 1 |..| (Text.russian.count - n.item + 1) as index loop
					zstr := Text.russian
					create array.make_from_unencoded (zstr)
					lower := index.item; upper := index.item + n.item - 1
					array.remove_substring (lower, upper)
					zstr.remove_substring (lower, upper)
					assert ("same content", same_content (array, zstr))
				end
			end
		end

	test_shift_from
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.shift_from"
		local
			array: EL_SUBSTRING_32_ARRAY; unencoded: EL_COMPACT_SUBSTRINGS_32
			zstr, padded: ZSTRING; count: INTEGER
		do
			zstr := Text.russian
			count := zstr.count
			across 1 |..| count as index loop
				padded := zstr + create {ZSTRING}.make_filled (' ', count)
				array := padded; unencoded := padded
				array.shift_from (index.item, count)
				create unencoded.make_from_other (unencoded)
				unencoded.shift_from (index.item, count)
				assert ("same content", same_content (array, unencoded))
			end
		end

	test_sub_array
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.sub_array"
		local
			zstr, substring: ZSTRING; i, i_last, substring_count: INTEGER
			array, sub_array: EL_COMPACT_SUBSTRINGS_32; extendable: EL_COMPACT_SUBSTRINGS_32_BUFFER
		do
			zstr := Text.russian
			create extendable.make
			across 1 |..| 5 as n loop
				substring_count := n.item
				i_last := zstr.count - substring_count
				from i := 1 until i > i_last loop
					substring := zstr.substring (i, i + substring_count - 1)
					array := zstr
					extendable.wipe_out
					extendable.append_substring (array, i, i + substring_count - 1, 0)
					create sub_array.make_from_other (extendable)
					assert ("same content", same_content (substring, sub_array))
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
			across Text.lines as line loop
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
			zstr: ZSTRING; unencoded: EL_COMPACT_SUBSTRINGS_32
		do
			zstr := Text.russian
			unencoded := zstr
			unencoded.to_upper; zstr.to_upper
			assert ("same content", same_content (zstr, unencoded))
		end

	test_write
		note
			testing: "covers/{EL_SUBSTRING_32_ARRAY}.make_from_unencoded", "covers/{EL_SUBSTRING_32_ARRAY}.write"
		do
			for_each_line (agent compare_write_output)
		end

feature {NONE} -- Implementation

	compare_character_count (zstr: ZSTRING; unencoded: EL_COMPACT_SUBSTRINGS_32)
		do
			assert ("same character_count", unencoded.character_count = to_array (zstr).character_count)
			assert ("same utf_8_byte_count", unencoded.utf_8_byte_count = to_array (zstr).utf_8_byte_count)
		end

	compare_codes (zstr: ZSTRING; array: EL_COMPACT_SUBSTRINGS_32)
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

	compare_first_interval (zstr: ZSTRING; unencoded: EL_COMPACT_SUBSTRINGS_32)
		do
			if unencoded.not_empty then
				assert ("same first_lower", unencoded.first_lower = to_array (zstr).first_lower)
				assert ("same first_upper", unencoded.first_upper = to_array (zstr).first_upper)
			else
				assert ("empty unencoded", unencoded.area.count = 0)
			end
		end

	compare_hash_code (zstr: ZSTRING; unencoded: EL_COMPACT_SUBSTRINGS_32)
		do
			assert ("same hash_code", to_array (zstr).hash_code (50) = unencoded.hash_code (50))
		end

	compare_index_of (zstr: ZSTRING; unencoded: EL_COMPACT_SUBSTRINGS_32)
		local
			i, last_index: INTEGER; uc: CHARACTER_32
		do
			from i := 1 until i > zstr.count loop
				if zstr.z_code (i) > 0xFF then
					uc := zstr [i]
					assert ("same index_of", to_array (zstr).index_of (uc, 1) = unencoded.index_of (uc, 1, null))
					last_index := to_array (zstr).last_index_of (uc, zstr.count)
					assert ("same last_index_of", last_index = unencoded.last_index_of (uc, zstr.count))
				end
				i := i + 1
			end
		end

	compare_occurrences (zstr: ZSTRING; unencoded: EL_COMPACT_SUBSTRINGS_32)
		local
			i: INTEGER; uc: CHARACTER_32
		do
			from i := 1 until i > zstr.count loop
				if zstr.z_code (i) > 0xFF then
					uc := zstr [i]
					assert ("same occurrences", to_array (zstr).occurrences (uc) = unencoded.occurrences (uc))
				end
				i := i + 1
			end
		end

	compare_write_output (zstr: ZSTRING; unencoded: EL_COMPACT_SUBSTRINGS_32)
		do
			assert ("same content", same_content (zstr, unencoded))
		end

	for_each_line (test: PROCEDURE [ZSTRING, EL_COMPACT_SUBSTRINGS_32])
		local
			zstr: ZSTRING; unencoded: EL_COMPACT_SUBSTRINGS_32
		do
			across Text.lines as line loop
				zstr := line.item
				unencoded := zstr
				test (zstr, unencoded)
			end
		end

	null: TYPED_POINTER [INTEGER]
		do
		end

	to_array (zstr: ZSTRING): EL_SUBSTRING_32_ARRAY
		do
			Result := zstr
		end

	same_content (array: EL_SUBSTRING_32_ARRAY; unencoded: EL_COMPACT_SUBSTRINGS_32): BOOLEAN
		local
			output_1, output_2: STRING_32
		do
			if array.not_empty then
				if array.first_lower = unencoded.first_lower and then array.last_upper = unencoded.last_upper then
					create output_1.make_filled (' ', array.last_upper)
					array.write (output_1.area, 0)

					create output_2.make_filled (' ', unencoded.last_upper)
					unencoded.write (output_2.area, 0, False)

					Result := output_1 ~ output_2
				end
			else
				Result := not array.not_empty
			end
		end

end