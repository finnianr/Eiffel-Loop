note
	description: "Hash table test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-21 10:19:15 GMT (Saturday 21st October 2023)"
	revision: "26"

class
	HASH_TABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	JSON_TEST_DATA

	FEATURE_CONSTANTS

	EL_MODULE_EIFFEL; EL_MODULE_EXECUTABLE; EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["character_32_table",				 agent test_character_32_table],
				["compressed_table",					 agent test_compressed_table],
				["hash_table_insertion",			 agent test_hash_table_insertion],
				["immutable_string_table",			 agent test_immutable_string_table],
				["immutable_string_table_memory", agent test_immutable_string_table_memory],
				["immutable_utf_8_table",			 agent test_immutable_utf_8_table],
				["iteration_cursor",					 agent test_iteration_cursor],
				["readable_string_8_table",		 agent test_readable_string_8_table],
				["string_table",						 agent test_string_table],
				["table_sort",							 agent test_table_sort]
			>>)
		end

feature -- Test

	test_character_32_table
		note
			testing: "covers/{EL_HASH_TABLE}.make_from_manifest_32"
		do
			if attached new_character_entity_table as table then
				assert ("is pound", table ["pound"] = '£')
				assert ("is curren", table ["curren"] = '¤')
				assert ("is yen", table ["yen"] = '¥')
				assert ("is copy", table ["copy"] = '©')
			end
		end

	test_compressed_table
		note
			testing: "covers/{EL_SETTABLE_FROM_JSON_STRING}.set_from_json"
		local
			geo_info_table: EL_COMPRESSION_TABLE [EL_IP_ADDRESS_GEOGRAPHIC_INFO, NATURAL]
			geo_info: EL_IP_ADDRESS_GEOGRAPHIC_INFO; compression_ratio: DOUBLE
		do
			create geo_info.make_from_json (JSON_eiffel_loop_ip)
			assert ("country_area rounded up", geo_info.country_area = 244821) -- 244820.6

			create geo_info_table.make (11)
			geo_info_table.put (geo_info, geo_info.ip)
			assert ("same object", geo_info = geo_info_table.found_item)
			compression_ratio := geo_info_table.size_compressed_item / geo_info.deep_physical_size
			lio.put_integer_field ("Compression ratio", (compression_ratio * 100).rounded); lio.put_string ("%%")
			lio.put_new_line

			geo_info_table.put (geo_info, geo_info.ip)
			assert ("same value", geo_info /= geo_info_table.found_item and geo_info ~ geo_info_table.found_item)

			assert ("same value", geo_info ~ geo_info_table.found_item)
			if geo_info_table.has_key (geo_info.ip) then
				assert ("same value", geo_info ~ geo_info_table.found_item)
			else
				failed ("table has geo_info")
			end
			geo_info_table.put (geo_info, geo_info.ip)
			assert ("same value", geo_info ~ geo_info_table.found_item)
		end

	test_hash_table_insertion
		-- HASH_TABLE_TEST_SET.test_hash_table_insertion
		note
			testing: "[
				covers/{EL_HASH_TABLE}.put, covers/{EL_HASH_SET}.put, covers/{EL_HASH_SET}.put_copy
			]"
		local
			table: EL_HASH_TABLE [CHARACTER, STRING]; set: EL_HASH_SET [STRING]
			key: STRING
		do
			create table.make_equal (20)
			create set.make (20)

			across 1 |..| 2 as n loop
				table.put ('a', "a")
				if n.item = 1 then
					assert ("inserted", table.inserted)
				else
					assert ("conflict", table.conflict)
				end
				set.put ("A")
				if n.item = 1 then
					assert ("inserted", set.inserted)
				else
					assert ("conflict", set.conflict)
				end
			end
			key := "ABC"
			set.put_copy (key)
			if set.has_key (key) then
				assert ("has copy", set.found_item ~ key and set.found_item /= key)
			else
				failed ("has_key")
			end
			set.put (key)
			assert ("conflict", set.conflict)
			assert ("has copy", set.found_item ~ key and set.found_item /= key)
		end

	test_immutable_string_table
		-- HASH_TABLE_TEST_SET.test_immutable_string_table
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_TABLE}.make,
				covers/{EL_IMMUTABLE_STRING_TABLE}.make_by_assignment
			]"
		local
			assigment_manifest: EL_STRING_8_LIST; feature_expansion_table_2: EL_IMMUTABLE_STRING_8_TABLE
		do
			create assigment_manifest.make (Feature_expansion_table.count)
			across Feature_expansion_table as table loop
				assigment_manifest.extend (table.key + " := " + table.item)
			end
			create feature_expansion_table_2.make_by_assignment (assigment_manifest.joined_lines)
			if Feature_expansion_table.count = feature_expansion_table_2.count then
				across Feature_expansion_table as table loop
					if feature_expansion_table_2.has_immutable_key (table.key) then
						assert ("same item value", table.item ~ feature_expansion_table_2.found_item)
					else
						failed ("missing key " + table.key)
					end
				end
			else
				failed ("same count")
			end
		end

	test_immutable_string_table_memory
		-- HASH_TABLE_TEST_SET.test_immutable_string_table_memory
		note
			testing: "covers/{EL_IMMUTABLE_STRING_TABLE}.make"
		local
			standard_table: HASH_TABLE [STRING, STRING]
			item_count, table_object_count, objects_per_string, objects_per_immutable,
			standard_size, immutable_size, standard_object_count, immutable_object_count: INTEGER
		do
			create standard_table.make_equal (Feature_expansion_table.count)
			across Feature_expansion_table as table loop
				standard_table.extend (table.item, table.key)
			end
			immutable_size := Eiffel.deep_physical_size (Feature_expansion_table)
			standard_size := Eiffel.deep_physical_size (standard_table)
			lio.put_integer_field ("Standard size", standard_size)
			lio.put_integer_field (" Immutable size", immutable_size)
			lio.put_new_line
			assert ("56 %% less memory", 100 - (immutable_size * 100 / standard_size).rounded = 56)

			item_count := Feature_expansion_table.count
			table_object_count := 5; objects_per_string := 2; objects_per_immutable := 1

			standard_object_count := table_object_count + objects_per_string * 2 * item_count
			immutable_object_count := (table_object_count + objects_per_string) + objects_per_immutable * item_count
			lio.put_integer_field ("Table item count", item_count)
			lio.put_integer_field (" Standard object count", standard_object_count)
			lio.put_integer_field (" Immutable object count", immutable_object_count)
			lio.put_new_line

			assert ("71 %% fewer objects", 100 - (immutable_object_count * 100 / standard_object_count).rounded = 71)
		end

	test_immutable_utf_8_table
		-- HASH_TABLE_TEST_SET.test_immutable_utf_8_table
		note
			testing: "[
				covers/{EL_IMMUTABLE_UTF_8_TABLE}.make,
				covers/{EL_IMMUTABLE_UTF_8_TABLE}.found_item_list,
				covers/{EL_IMMUTABLE_STRING_TABLE}.make_by_assignment,
				covers/{EL_IMMUTABLE_STRING_TABLE}.found_item
			]"
		local
			table_utf_8: EL_IMMUTABLE_UTF_8_TABLE; value: ZSTRING
			zstring_table: EL_ZSTRING_TABLE; currency_table: EL_IMMUTABLE_STRING_32_TABLE
		do
			create table_utf_8.make_by_indented (Table_manifest)
			create zstring_table.make (Table_manifest)
			across zstring_table as table loop
				if table_utf_8.has_key_general (table.key) then
					value := table.item
					assert ("equal values", value ~ table_utf_8.found_item)
				else
					failed ("has immutable key")
				end
			end
			if table_utf_8.has_key_8 ("currency_symbols") then
				create currency_table.make_by_assignment (table_utf_8.found_item.to_string_32)
				if currency_table.has_key_general ("euro") and then
					attached currency_table.found_item as symbol
				then
					assert ("is euro symbol", symbol.count = 1 and then symbol [1] = '€')
				else
					failed ("found euro")
				end
			else
				failed ("found currency_symbols")
			end
		end

	test_iteration_cursor
		local
			table: EL_HASH_TABLE [INTEGER, INTEGER]
			list: ARRAYED_LIST [INTEGER]; step, value, index: INTEGER
		do
			create table.make_equal (10)
			create list.make (10)
			across 0 |..| 9 as n loop
				table.extend (n.item, n.item)
			end
			across 3 |..| 5 as key loop
				table.remove (key.item)
				across 1 |..| 4 as n loop
					step := n.item
					list.wipe_out
					across table.new_cursor + step as t loop
						value := t.item; index := t.cursor_index
						list.extend (value)
						assert ("same item", list [index] = list.last)
					end
				end
			end
		end

	test_readable_string_8_table
		-- HASH_TABLE_TEST_SET.test_readable_string_8_table
		note
			testing: "[
				covers/{EL_TUPLE_ROUTINES}.fill_immutable,
				covers/{EL_STRING_8_TABLE}.same_keys
			]"
		local
			value_table: EL_STRING_8_TABLE [INTEGER]
			name: TUPLE [one, two, three: IMMUTABLE_STRING_8]
		do
			create name
			Tuple.fill_immutable (name, "one, two, three")
			create value_table.make_size (3)
			across << name.one, name.two, name.three >> as list loop
				value_table [list.item] := list.cursor_index
			end
			across ("one,two,three").split (',') as list loop
				assert ("same number", value_table [list.item] = list.cursor_index)
			end
		end

	test_string_table
		local
			table: EL_STRING_HASH_TABLE [INTEGER, ZSTRING]
			key_1: ZSTRING; key_2: STRING_32; key_3: STRING
		do
			key_1 := "1"; key_2 := "2"; key_3 := "3"
			create table.make (<<
				[key_1, key_1.to_integer],
				[key_2, key_2.to_integer],
				[key_3, key_3.to_integer]
			>>)
			assert ("same value", table [key_1] = 1)
			assert ("same value", table [key_2] = 2)
			assert ("same value", table [key_3] = 3)
		end

	test_table_sort
		-- HASH_TABLE_TEST_SET.test_table_sort
		local
			names: HEXAGRAM_NAMES; hanzi: IMMUTABLE_STRING_32
			name_list: EL_SORTABLE_ARRAYED_LIST [IMMUTABLE_STRING_32]
			name_table: EL_HASH_TABLE [INTEGER, IMMUTABLE_STRING_32]
			i, number: INTEGER
		do
			create name_table.make_equal (64)
			create name_list.make (64)
			from i := 1 until i > 64 loop
				hanzi := names.i_th_hanzi_characters (i)
				name_list.extend (hanzi)
				name_table.extend (i, hanzi)
				i := i + 1
			end
			name_list.ascending_sort
			from name_table.start until name_table.item_for_iteration = 8 loop
				name_table.forth
			end
			name_table.sort_by_key (True)
			assert ("same iteration item", name_table.item_for_iteration = 8)

			across name_table as table loop
				number := table.item; i := table.cursor_index
				hanzi := table.key
				assert ("same hanzi by table cursor index", hanzi ~ name_list [i])
				assert ("same hanzi by table key", hanzi ~ names.i_th_hanzi_characters (number))
			end

			from i := 1 until i > 64 loop
				hanzi := names.i_th_hanzi_characters (i)
				assert ("has key", name_table.has (hanzi))
				i := i + 1
			end
			name_table.ascending_sort
			across name_table as table loop
				assert ("item same as cursor index", table.cursor_index = table.item)
			end

			-- Test with deletions
			name_list.wipe_out
			from i := 1 until i > 64 loop
				hanzi := names.i_th_hanzi_characters (i)
				if names.i_th_pinyin_name (i) [1] = 'S' then
					name_table.remove (hanzi)
				else
					name_list.extend (hanzi)
				end
				i := i + 1
			end
			name_list.reverse_sort
			name_table.sort_by_key (False)
			assert ("same iteration item", name_table.item_for_iteration = 8)

			assert ("same count", name_list.count = name_table.count)
			across name_table as table loop
				number := table.item; i := table.cursor_index
				hanzi := table.key
				assert ("same hanzi by table cursor index", hanzi ~ name_list [i])
			end
		end

feature {NONE} -- Implementation

	new_character_entity_table: EL_HASH_TABLE [CHARACTER_32, ZSTRING]
		-- map entity name to character
		do
			create Result.make_from_manifest_32 (
				agent new_zstring, agent {IMMUTABLE_STRING_32}.item (1), True, {STRING_32} "[
				pound := £
				curren := ¤
				yen := ¥
				copy := ©
			]")
		end

	new_zstring (str: IMMUTABLE_STRING_32): ZSTRING
		do
			create Result.make_from_general (str)
		end

feature {NONE} -- Constants

	Table_manifest: STRING_32 = "[
		is_boolean:
			True
		currency_symbols:
			any := ¤
			euro := €
			pound := £
			yen := ¥
	]"

end