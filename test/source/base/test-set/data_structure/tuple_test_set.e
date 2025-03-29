note
	description: "Test routines for initializing ${TUPLE} objects from strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 12:05:50 GMT (Saturday 29th March 2025)"
	revision: "3"

class TUPLE_TEST_SET inherit EL_EQA_TEST_SET

	EL_MODULE_CONVERT_STRING; EL_MODULE_TUPLE

	EL_SHARED_STRING_8_CURSOR

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
				if attached cursor_8 (list.item).area as item_area then
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
		local
			t1: TUPLE [animal: ZSTRING; letter: CHARACTER; weight: DOUBLE; age: INTEGER]
			t2: TUPLE [currency: IMMUTABLE_STRING_8; symbol: STRING_32]
			data_lines: STRING_32; data_str: READABLE_STRING_GENERAL
			string_types: ARRAY [TYPE [ANY]]; type: TYPE [ANY]; is_string_8: BOOLEAN
		do
			data_lines := {STRING_32} "cat, C, 6.5, 4%NEuro, €"
			string_types := << {STRING_8}, {STRING_32}, {ZSTRING}, {IMMUTABLE_STRING_8}, {IMMUTABLE_STRING_32} >>

			across data_lines.split ('%N') as list loop
				data_str := list.item
				across string_types as types loop
					type := types.item
					if Convert_string.is_convertible (data_str, type) then
						if attached Convert_string.to_type (data_str, type) as general
							and then attached {READABLE_STRING_GENERAL} general as converted_str
						then
							data_str := converted_str
							if data_str.occurrences (',') = 3 then
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
								assert ("same symbol", t2.symbol.count = 1 and data_lines.ends_with (t2.symbol))
							end
						end
					else
						is_string_8 := {ISE_RUNTIME}.type_conforms_to (type.type_id, ({READABLE_STRING_8}).type_id)
						assert ("euro not convertible to 8-bit string", data_str.starts_with ("Euro") and is_string_8)
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