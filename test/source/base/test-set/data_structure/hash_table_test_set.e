note
	description: "Hash table test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 19:09:47 GMT (Friday 13th September 2024)"
	revision: "45"

class
	HASH_TABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EIFFEL; EL_MODULE_EXECUTABLE

	EL_STRING_GENERAL_ROUTINES

	JSON_TEST_DATA

	EL_SHARED_TEST_TEXT

	EL_CHARACTER_32_CONSTANTS; FEATURE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["character_32_table",				 agent test_character_32_table],
				["code_text_table",					 agent test_code_text_table],
				["compressed_table",					 agent test_compressed_table],
				["hash_table_insertion",			 agent test_hash_table_insertion],
				["immutable_error_code_table",	 agent test_immutable_error_code_table],
				["immutable_string_32_table",		 agent test_immutable_string_32_table],
				["immutable_string_8_table",		 agent test_immutable_string_8_table],
				["immutable_string_table_memory", agent test_immutable_string_table_memory],
				["immutable_utf_8_table",			 agent test_immutable_utf_8_table],
				["iteration_cursor",					 agent test_iteration_cursor],
				["string_general_table",			 agent test_string_general_table],
				["string_table",						 agent test_string_table],
				["table_sort",							 agent test_table_sort],
				["zstring_table",						 agent test_zstring_table]
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

	test_code_text_table
		-- HASH_TABLE_TEST_SET.test_code_text_table
		note
			testing: "[
				covers/{EL_CODE_TEXT_TABLE_I}.has_key,
				covers/{EL_CODE_TEXT_TABLE_I}.item
			]"
		local
			table: EL_CODE_TEXT_TABLE; unknown: ZSTRING
			compressed_table: EL_COMPRESSED_CODE_TEXT_TABLE
		do
			unknown := "Unknown"
			create table.make_with_default (unknown, Zlib_code_table)
			assert ("valid manifest table", table.valid_manifest (Zlib_code_table))
			assert_valid_code (table, 0, "No|successful.", 1)
			assert_valid_code (table, -1, "A|zlib.", 2)
			assert_valid_code (table, -6, "The|application.", 2)

			assert ("default is unknown", table [10] = unknown)
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
				covers/{EL_HASH_TABLE}.put,
				covers/{EL_HASH_SET}.put,
				covers/{EL_HASH_SET}.put_copy
			]"
		local
			table: EL_HASH_TABLE [CHARACTER, STRING]; set: EL_HASH_SET [STRING]
			key: STRING
		do
			create table.make_equal (20)
			create set.make_equal (20)

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

	test_immutable_error_code_table
		-- HASH_TABLE_TEST_SET.test_immutable_error_code_table
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_TABLE}.make_code_map,
				covers/{EL_IMMUTABLE_STRING_TABLE}.found_item_unindented,
				covers/{EL_IMMUTABLE_STRING_8_TABLE}.has_key_code,
				covers/{EL_CODE_TEXT_TABLE}.has_key,
				covers/{EL_CODE_TEXT_TABLE}.item
			]"
		local
			error_table: EL_IMMUTABLE_STRING_8_TABLE; manifest: STRING
			code_table: EL_CODE_TEXT_TABLE; code: INTEGER_64
		do
			manifest := File.plain_text ("data/code/C/windows/error-codes.txt")
			manifest.right_adjust
			create error_table.make ({EL_TABLE_FORMAT}.Indented_code, manifest)
			if error_table.has_key_code (51) and then attached error_table.found_item_lines as lines then
				assert ("3 lines", lines.count = 3)
				assert ("starts with Windows", lines.first_item.starts_with ("Windows"))
				assert ("starts with administrator.", lines.last_item.ends_with ("administrator."))
				if attached error_table.found_item_unindented as unindented then
					assert ("3 lines", unindented.occurrences ('%N') = 2)
					assert ("starts with Windows", unindented.starts_with ("Windows"))
					assert ("starts with administrator.", unindented.ends_with ("administrator."))
				end
			else
				failed ("has code 51")
			end
			if error_table.has_key_code (5) and then attached error_table.found_item_unindented as unindented then
				assert_same_string (Void, unindented, "Access is denied.")
			else
				failed ("has code 5")
			end
			create code_table.make (manifest)
			across error_table.current_keys as key loop
				if error_table.has_immutable_key (key.item) then
					code := key.item.to_string_8.to_integer_64
					assert_same_string ("same item", error_table.found_item_unindented, code_table [code])
				else
					failed ("has key")
				end
			end
		end

	test_immutable_string_32_table
		-- HASH_TABLE_TEST_SET.test_immutable_string_32_table
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_TABLE}.make,
				covers/{EL_IMMUTABLE_STRING_TABLE}.make_assignments,
				covers/{EL_IMMUTABLE_STRING_TABLE}.has_key_general
			]"
		local
			currency_name_table: EL_IMMUTABLE_STRING_32_TABLE
			key_list: ARRAYED_LIST [READABLE_STRING_GENERAL]
			symbol: STRING_32
		do
			create currency_name_table.make_assignments (Currency_name_manifest)
			across Currency_name_manifest.split ('%N') as split loop
				if attached split.item as line then
					symbol := line.substring (1, 1)
					create key_list.make_from_array (<<
						symbol, create {IMMUTABLE_STRING_32}.make_from_string_32 (symbol), as_zstring (symbol)
					>>)
					if symbol.is_valid_as_string_8 then
						key_list.extend (symbol.to_string_8)
					end
					across key_list as key loop
						if currency_name_table.has_key_general (key.item) then
							assert ("name matches", line.ends_with (currency_name_table.found_item))
						else
							failed (symbol + " name not found")
						end
					end
				end
			end
		end

	test_immutable_string_8_table
		-- HASH_TABLE_TEST_SET.test_immutable_string_8_table
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_TABLE}.make,
				covers/{EL_IMMUTABLE_STRING_TABLE}.make_assignments,
				covers/{EL_IMMUTABLE_STRING_TABLE}.has_key_general
			]"
		local
			assigment_manifest: EL_STRING_8_LIST; feature_expansion_table_2: EL_IMMUTABLE_STRING_8_TABLE
			key_array: ARRAY [READABLE_STRING_GENERAL]
		do
			create assigment_manifest.make (Feature_expansion_table.count)
			across Feature_expansion_table as table loop
				assigment_manifest.extend (table.key + " := " + table.item)
			end
			create feature_expansion_table_2.make_assignments (assigment_manifest.joined_lines)
			if Feature_expansion_table.count = feature_expansion_table_2.count then
				across Feature_expansion_table as table loop
					key_array := << table.key, table.key.to_string_8, table.key.to_string_32, as_zstring (table.key) >>
					across key_array as key loop
						if feature_expansion_table_2.has_key_general (key.item) then
							assert ("same item value", table.item ~ feature_expansion_table_2.found_item)
						else
							failed ("missing key " + table.key)
						end
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
			assert ("56 %% less memory", 100 - immutable_size * 100 // standard_size = 56)

			item_count := Feature_expansion_table.count
			table_object_count := 5; objects_per_string := 2; objects_per_immutable := 1

			standard_object_count := table_object_count + objects_per_string * 2 * item_count
			immutable_object_count := (table_object_count + objects_per_string) + objects_per_immutable * item_count
			lio.put_integer_field ("Table item count", item_count)
			lio.put_integer_field (" Standard object count", standard_object_count)
			lio.put_integer_field (" Immutable object count", immutable_object_count)
			lio.put_new_line

			assert ("71 %% fewer objects", 100 - immutable_object_count * 100 // standard_object_count = 71)
		end

	test_immutable_utf_8_table
		-- HASH_TABLE_TEST_SET.test_immutable_utf_8_table
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_TABLE}.make_assignments,
				covers/{EL_IMMUTABLE_STRING_TABLE}.make,
				covers/{EL_IMMUTABLE_STRING_TABLE}.make_reversed,
				covers/{EL_IMMUTABLE_STRING_TABLE}.key_for_iteration,
				covers/{EL_IMMUTABLE_STRING_TABLE}.item_for_iteration,
				covers/{EL_IMMUTABLE_STRING_TABLE}.found_item,
				covers/{EL_IMMUTABLE_STRING_TABLE}.found_item_unindented,
				covers/{EL_IMMUTABLE_UTF_8_TABLE}.found_item,
				covers/{EL_IMMUTABLE_UTF_8_TABLE}.new_item,
				covers/{EL_IMMUTABLE_UTF_8_TABLE}.key_for_iteration,
				covers/{EL_IMMUTABLE_UTF_8_TABLE}.item_for_iteration,
				covers/{EL_SPLIT_IMMUTABLE_UTF_8_LIST}.append_lines_to,
				covers/{EL_STRING_X_ROUTINES}.new_from_lines
			]"
		local
			table_utf_8, currency_table_utf_8_reversed, currency_table_utf_8: EL_IMMUTABLE_UTF_8_TABLE
			zstring_table: EL_ZSTRING_TABLE; currency_table: EL_IMMUTABLE_STRING_32_TABLE
			value, euro_symbol, line: ZSTRING; euro_name: STRING
			key_list: ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			create table_utf_8.make ({EL_TABLE_FORMAT}.Indented_eiffel, Currency_manifest)

			zstring_table := Currency_manifest
			across zstring_table as table loop
				if table_utf_8.has_key_general (table.key) then
					value := table.item
					assert ("equal values", value ~ table_utf_8.found_item)
				else
					failed ("has immutable key")
				end
			end
			if table_utf_8.has_key_8 ("currency_symbols") then
				euro_name := "euro"; create euro_symbol.make_filled (Text.Euro_symbol, 1)
				create currency_table.make_assignments (table_utf_8.found_item)
				create currency_table_utf_8.make_assignments_utf_8 (table_utf_8.found_item_unindented)

				if currency_table.has_key_general (euro_name) and then
					attached currency_table.found_item as symbol
				then
					assert ("is euro symbol", symbol.count = 1 and then symbol [1] = Text.Euro_symbol)
				else
					failed ("found euro")
				end
				if currency_table_utf_8.has_key_8 (euro_name) then
					assert_same_string (Void, currency_table_utf_8.found_item, euro_symbol)
				else
					failed ("has euro entry")
				end
				create currency_table_utf_8_reversed.make_reversed (currency_table_utf_8)
				if attached currency_table_utf_8 as table then
					from table.start until table.after loop
						if attached table.item_for_iteration as key then
							create key_list.make_from_array (<< key, key.to_string_32 >>)
							if key.is_valid_as_string_8 then
								key_list.extend (key.to_string_8)
							end
						end
						across key_list as key loop
							if currency_table_utf_8_reversed.has_key_general (key.item) then
								assert_same_string (Void, table.zkey_for_iteration, currency_table_utf_8_reversed.found_item)
							else
								failed ("reverse lookup succeeded")
							end
						end
						table.forth
					end
				end
				if attached currency_table_utf_8_reversed as table then
					from table.start until table.after loop
						if currency_table_utf_8.has_key_general (table.item_for_iteration) then
							assert_same_string (Void, table.zkey_for_iteration, currency_table_utf_8.found_item)
						else
							failed ("lookup succeeded")
						end
						table.forth
					end
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

	test_string_general_table
		-- HASH_TABLE_TEST_SET.test_string_general_table
		local
			key_list, search_key_list: ARRAYED_LIST [READABLE_STRING_GENERAL]
			table: EL_STRING_GENERAL_TABLE [INTEGER]; key: READABLE_STRING_GENERAL
		do
			create table.make_size (3)
			across Currency_name_manifest.split ('%N') as line loop
				across new_string_type_list (line.item) as key_type loop
					key := key_type.item
					table.wipe_out
					table.extend (key.count, key)
					across new_string_type_list (key) as list loop
						if attached list.item as search_key then
							if table.has_key (search_key) then
								assert ("same count", table.found_item = search_key.count)
							else
								failed ("key not found")
							end
						end
					end
				end
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

	test_zstring_table
		-- HASH_TABLE_TEST_SET.test_zstring_table
		note
			testing: "[
				covers/{EL_ZSTRING_TABLE}.make,
				covert/{EL_TABLE_INTERVAL_MAP_LIST}.make
			]"
		local
			currency_table: EL_ZSTRING_TABLE; manifest: ZSTRING
		do
			manifest := Currency_manifest
			currency_table := Currency_manifest
			across currency_table as table loop
				if attached table.item.split ('%N') as item_lines then
					lio.put_labeled_lines (table.key, item_lines)
					assert ("found in manifest", manifest.has_substring (table.key + char (':').as_string_8 (1)))
					assert ("at least one line", item_lines.count > 0)
					across item_lines as line loop
						assert ("found in manifest", manifest.has_substring (Tab + line.item))
					end
				end
			end
		end

feature {NONE} -- Implementation

	assert_valid_code (table: EL_CODE_TEXT_TABLE; key: INTEGER_64; start_end: STRING; line_count: INTEGER)
		local
			key_str: STRING
		do
			key_str := key.out
			if table.has_key (key) then
				assert (line_count.out + " lines", table.found_item.occurrences ('%N') + 1 = line_count)
				assert ("not indented", not table.found_item.has ('%T'))
				if attached start_end.split ('|') as split then
					assert ("found " + key_str, table.found_item.starts_with_general (split [1]))
					assert ("found " + key_str, table.found_item.ends_with_general (split [2]))
				end
			else
				failed ("Find code " + key_str)
			end
		end

	immutable_to_zstring (str: IMMUTABLE_STRING_32): ZSTRING
		do
			create Result.make_from_general (str)
		end

	new_character_entity_table: EL_HASH_TABLE [CHARACTER_32, ZSTRING]
		-- map entity name to character
		do
			create Result.make_from_manifest_32 (
				agent immutable_to_zstring, agent {IMMUTABLE_STRING_32}.item (1), True, {STRING_32} "[
				pound := £
				curren := ¤
				yen := ¥
				copy := ©
			]")
		end

	new_string_type_list (str: READABLE_STRING_GENERAL): ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			create Result.make_from_array (<<
				str.to_string_32, create {IMMUTABLE_STRING_32}.make_from_string (str.to_string_32),
				create {ZSTRING}.make_from_general (str)
			>>)
			if str.is_valid_as_string_8 then
				Result.extend (str.to_string_8)
				Result.extend (create {IMMUTABLE_STRING_8}.make_from_string (str.to_string_8))
			end
		end

feature {NONE} -- Constants

	Currency_manifest: STRING_32 = "[
		is_boolean:
			True
		currency_symbols:
			any := ¤
			euro := €
			pound := £
			yen := ¥
	]"

	Currency_name_manifest: STRING_32 = "[
		¤ := any
		€ := euro
		£ := pound
		¥ := yen
	]"

	Zlib_code_table: STRING = "[
		0:
			No error, the operation was successful.
		-1:
			A generic error code indicating an I/O error. It typically means there
			was an error in the file handling outside of zlib.
		-6:
			The zlib library version used is incompatible with the version of the library
			expected by the application.
	]"
end