note
	description: "Routines for populating tuple fields. Accessible via shared instance [$source EL_MODULE_TUPLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-15 16:02:50 GMT (Friday 15th January 2021)"
	revision: "14"

class
	EL_TUPLE_ROUTINES

inherit
	ANY

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

feature -- Basic operations

	fill (tuple: TUPLE; csv_list: STRING_GENERAL)
		do
			fill_adjusted (tuple, csv_list, True)
		end

	fill_adjusted (tuple: TUPLE; csv_list: STRING_GENERAL; left_adjusted: BOOLEAN)
		-- fill tuple with STRING items from comma-separated list `csv_list' of strings
		-- TUPLE may contain any of types STRING_8, STRING_32, ZSTRING
		-- items are left adjusted if `left_adjusted' is True
		require
			valid_comma_count: csv_list.occurrences (',') = tuple.count - 1
		local
			tuple_type: TYPE [TUPLE]; item_type: TYPE [ANY]; type_id, csv_list_type_id: INTEGER
			list: like new_split_list; item_str: STRING_GENERAL
		do
			tuple_type := tuple.generating_type
			csv_list_type_id := {ISE_RUNTIME}.dynamic_type (csv_list)
			list := new_split_list (csv_list)
			if left_adjusted then
				list.enable_left_adjust
			end
			from list.start until list.index > tuple.count or list.after loop
				item_str := list.item (False)
				item_type := tuple_type.generic_parameter_type (list.index)
				type_id := item_type.type_id
				inspect tuple.item_code (list.index)
					when {TUPLE}.Reference_code then
						if csv_list_type_id = type_id then
							tuple.put_reference (item_str.twin, list.index)
						elseif attached new_item (type_id, item_str) as new then
							tuple.put_reference (new, list.index)
						else
							check i_th_type_convertible: True end
						end
					when {TUPLE}.Boolean_code then
						tuple.put_boolean (item_str.to_boolean, list.index)
					when {TUPLE}.Character_8_code then
						if item_str.count > 0 then
							tuple.put_character (item_str.item (1).to_character_8, list.index)
						end
					when {TUPLE}.Character_32_code then
						if item_str.count > 0 then
							tuple.put_character_32 (item_str.item (1), list.index)
						end
					when {TUPLE}.Real_32_code then
						tuple.put_real_32 (item_str.to_real_32, list.index)
					when {TUPLE}.Real_64_code then
						tuple.put_real_64 (item_str.to_real_64, list.index)

					when {TUPLE}.Integer_8_code then
						tuple.put_integer_8 (item_str.to_integer_8, list.index)
					when {TUPLE}.Integer_16_code then
						tuple.put_integer_16 (item_str.to_integer_16, list.index)
					when {TUPLE}.Integer_32_code then
						tuple.put_integer_32 (item_str.to_integer_32, list.index)
					when {TUPLE}.Integer_64_code then
						tuple.put_integer_64 (item_str.to_integer_64, list.index)

					when {TUPLE}.Natural_8_code then
						tuple.put_natural_8 (item_str.to_natural_8, list.index)
					when {TUPLE}.Natural_16_code then
						tuple.put_natural_16 (item_str.to_natural_16, list.index)
					when {TUPLE}.Natural_32_code then
						tuple.put_natural_32 (item_str.to_natural_32, list.index)
					when {TUPLE}.Natural_64_code then
						tuple.put_natural_64 (item_str.to_natural_64, list.index)
				else
					check i_th_type_convertible: True end
				end
				list.forth
			end
		ensure
			filled: across 1 |..| tuple.count as index all attached tuple.reference_item (index.item) end
		end

	fill_default (tuple: TUPLE; default_value: ANY)
		local
			i: INTEGER; type_id: INTEGER
			tuple_type: TYPE [TUPLE]
		do
			type_id := {ISE_RUNTIME}.dynamic_type (default_value)
			tuple_type := tuple.generating_type
			from i := 1 until i > tuple.count loop
				if tuple.item_code (i) = {TUPLE}.Reference_code and then
					Eiffel.field_conforms_to (type_id, tuple_type.generic_parameter_type (i).type_id)
				then
					tuple.put_reference (default_value, i)
				end
				i := i + 1
			end
		ensure
			filled: across 1 |..| tuple.count as index all attached tuple.reference_item (index.item) end
		end

	fill_with_new (tuple: TUPLE; csv_field_list: STRING; a_new_item: FUNCTION [STRING, ANY]; start_index: INTEGER)
		-- fill tuple from `start_index' with factory function call `a_new_item (x)' where `x' is a field name
		-- in the comma separated field list `csv_field_list'
		require
			valid_start_index: start_index >= 1
			valid_list: csv_field_list.count > 0 and then start_index + csv_field_list.occurrences (',') <= tuple.count
			not_filled:	across start_index |..| (start_index + csv_field_list.occurrences (',')) as n all
								not attached tuple.reference_item (n.item)
							end
		local
			result_type_id: INTEGER; list: EL_SPLIT_STRING_8_LIST
			tuple_type: TYPE [TUPLE]; index: INTEGER
		do
			result_type_id := a_new_item.generating_type.generic_parameter_type (2).type_id
			tuple_type := tuple.generating_type
			create list.make (csv_field_list, Comma)
			list.enable_left_adjust

			from list.start until (start_index + list.index - 1) > tuple.count or list.after loop
				index := start_index + list.index - 1
				if tuple.item_code (index) = {TUPLE}.Reference_code and then
					Eiffel.field_conforms_to (result_type_id, tuple_type.generic_parameter_type (index).type_id)
					and then attached a_new_item (list.item (False)) as new
				then
					tuple.put_reference (new, index)
				end
				list.forth
			end
		ensure
			filled:	across start_index |..| (start_index + csv_field_list.occurrences (',')) as n all
							attached tuple.reference_item (n.item)
						end
		end

	to_string_32_list (tuple: TUPLE): EL_STRING_32_LIST
		do
			Result := tuple
		end

	to_string_8_list (tuple: TUPLE): EL_STRING_8_LIST
		do
			Result := tuple
		end

	to_zstring_list (tuple: TUPLE): EL_ZSTRING_LIST
		do
			Result := tuple
		end

feature {NONE} -- Implementation

	new_split_list (csv_list: STRING_GENERAL): EL_SPLIT_STRING_LIST [STRING_GENERAL]
		do
			if csv_list.is_string_8 then
				create {EL_SPLIT_STRING_8_LIST} Result.make (csv_list.as_string_8, Comma)
			else
				create {EL_SPLIT_STRING_32_LIST} Result.make (csv_list.as_string_32, Comma)
			end
		end

	new_item (type_id: INTEGER; string: STRING_GENERAL): detachable ANY
		-- reference with dynamic type `type_id'
		do
			if type_id = Class_id.ZSTRING then
				create {ZSTRING} Result.make_from_general (string)

			elseif type_id = Class_id.STRING_8 and then string.is_valid_as_string_8 then
				create {STRING_8} Result.make_from_string (string.to_string_8)

			elseif type_id = Class_id.STRING_32 then
				create {STRING_32} Result.make_from_string (string)

			elseif type_id = Class_id.EL_FILE_PATH then
				create {EL_FILE_PATH} Result.make (string)

			elseif type_id = Class_id.EL_DIR_PATH then
				create {EL_DIR_PATH} Result.make (string)
			else
				check
					invalid_type_id: True
				end
			end
		ensure
			not_void: attached Result
		end

	put_item (tuple: TUPLE; index: INTEGER)
		do

		end

feature {NONE} -- Constants

	Comma: STRING = ","

end