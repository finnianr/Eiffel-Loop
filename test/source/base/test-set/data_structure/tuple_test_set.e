note
	description: "Test routines for initializing ${TUPLE} objects from strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 17:18:18 GMT (Sunday 20th April 2025)"
	revision: "6"

class TUPLE_TEST_SET inherit EL_EQA_TEST_SET

	EL_MODULE_CONVERT_STRING; EL_MODULE_TUPLE

	EL_SHARED_CHARACTER_AREA_ACCESS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["fill_immutable_tuple", agent test_fill_immutable_tuple],
				["fill_tuple",				 agent test_fill_tuple],
				["fill_with_new",			 agent test_fill_with_new]
			>>)
		end

feature -- Tests

	test_fill_immutable_tuple
		-- SPLIT_STRING_TEST_SET.test_fill_immutable_tuple
		note
			testing: "[
				covers/{EL_TUPLE_ROUTINES}.fill_immutable,
				covers/{EL_ARRAYED_LIST}.make_from_tuple,
				covers/{EL_STRING_8_TABLE}.same_keys
			]"
		local
			value_table: EL_STRING_8_TABLE [INTEGER]
			name: TUPLE [one, two, three: IMMUTABLE_STRING_8]
			name_list: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
			shared_area: detachable SPECIAL [CHARACTER]
		do
			create name
			Tuple.fill_immutable (name, "one, two, three")
			create name_list.make_from_tuple (name)
			assert ("same count", name_list.count = name.count)
			across name_list as list loop
				if attached Character_area_8.get_area (list.item) as item_area then
					if attached shared_area as area then
						assert ("same area", area = item_area)
					else
						shared_area := item_area
					end
				end
			end

			create value_table.make (3)
			across << name.one, name.two, name.three >> as list loop
				value_table [list.item] := list.cursor_index
			end
			across ("one,two,three").split (',') as list loop
				assert ("same number", value_table [list.item] = list.cursor_index)
			end
		end

	test_fill_tuple
		-- TUPLE_TEST_SET.test_fill_tuple
		note
			testing: "[
				covers/{EL_TUPLE_ROUTINES}.fill_from_list
			]"
		local
			t1: TUPLE [animal: ZSTRING; letter: CHARACTER; weight: DOUBLE; age: INTEGER]
			t2: TUPLE [currency: IMMUTABLE_STRING_8; symbol: CHARACTER_32]
			data_lines: STRING_32
		do
			data_lines := {STRING_32} "cat, C, 6.5, 4%NEuro, €"

			across data_lines.split ('%N') as line loop
				across new_string_type_list (line.item) as string loop
					if attached string.item as data_str then
						inspect data_str.occurrences (',')
							when 3 then
								create t1
								Tuple.fill (t1, data_str)
								assert ("cat", t1.animal.same_string ("cat"))
								assert ("C", t1.letter = 'C')
								assert ("6.5 kg", t1.weight = 6.5)
								assert ("4 years", t1.age = 4)
						else
							create t2
							tuple.fill (t2, data_str)
							assert ("same currency", t2.currency.same_string ("Euro"))
							assert ("same symbol", t2.symbol = data_lines [data_lines.count])
						end
					end
				end
			end
		end

	test_fill_with_new
		local
			t1: TUPLE [weight: DOUBLE; age: INTEGER; full_name, address: EL_STRING_8_LIST]
			name_and_address: STRING
		do
			create t1
			name_and_address := "Finnian Reilly, Dunboyne Co Meath"
			Tuple.fill_with_new (t1, name_and_address, agent new_word_list, 3)
			assert_same_string (Void, name_and_address, t1.full_name.as_word_string + ", " + t1.address.as_word_string)
		end

feature {NONE} -- Implementation

	new_word_list (str: STRING): EL_STRING_8_LIST
		do
			create Result.make_split (str, ' ')
		end

end