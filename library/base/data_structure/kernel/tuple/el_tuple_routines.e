note
	description: "Routines for populating tuple fields. Accessible via shared instance [$source EL_MODULE_TUPLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-16 13:33:09 GMT (Saturday 16th January 2021)"
	revision: "16"

class
	EL_TUPLE_ROUTINES

inherit
	ANY

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

	EL_MODULE_CONVERT_STRING

feature -- Basic operations

	fill (tuple: TUPLE; csv_list: STRING_GENERAL)
		do
			fill_adjusted (tuple, csv_list, True)
		end

	fill_adjusted (tuple: TUPLE; csv_list: STRING_GENERAL; left_adjusted: BOOLEAN)
		-- fill tuple with STRING items from comma-separated list `csv_list' of strings
		-- TUPLE may contain any of types STRING_8, STRING_32, ZSTRING
		-- items are left adjusted if `left_adjusted' is True
		do
			Convert_string.fill_tuple (tuple, csv_list, left_adjusted)
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
			filled: is_filled (tuple, 1, tuple.count)
		end

	fill_with_new (tuple: TUPLE; csv_field_list: STRING; a_new_item: FUNCTION [STRING, ANY]; start_index: INTEGER)
		-- fill tuple from `start_index' with factory function call `a_new_item (x)' where `x' is a field name
		-- in the comma separated field list `csv_field_list'
		require
			valid_start_index: start_index >= 1
			valid_list: csv_field_list.count > 0 and then start_index + csv_field_list.occurrences (',') <= tuple.count
			not_filled:	not is_filled (tuple, start_index, start_index + csv_field_list.occurrences (','))
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
			filled:is_filled (tuple, start_index, start_index + csv_field_list.occurrences (','))
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

feature -- Contract Support

	is_filled (tuple: TUPLE; start_index, end_index: INTEGER): BOOLEAN
		do
			Result := across start_index |..| end_index as i_th all
				tuple.is_reference_item (i_th.item) implies attached tuple.reference_item (i_th.item)
			end
		end

feature {NONE} -- Constants

	Comma: STRING = ","

end