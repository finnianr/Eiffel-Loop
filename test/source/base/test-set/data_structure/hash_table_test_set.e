note
	description: "Hash table test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	HASH_TABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	JSON_TEST_DATA

	EL_MODULE_LIO

	EL_MODULE_TUPLE

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("compressed_table", agent test_compressed_table)
			eval.call ("iteration_cursor", agent test_iteration_cursor)
			eval.call ("readable_string_8_table", agent test_readable_string_8_table)
			eval.call ("string_table", agent test_string_table)
		end

feature -- Test

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
				assert ("table has geo_info", False)
			end
			geo_info_table.put (geo_info, geo_info.ip)
			assert ("same value", geo_info ~ geo_info_table.found_item)
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
		note
			testing: "covers/{EL_TUPLE_ROUTINES}.fill_immutable", "covers/{EL_STRING_8_TABLE}.same_keys"
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
end