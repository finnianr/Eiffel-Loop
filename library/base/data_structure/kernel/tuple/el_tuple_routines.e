note
	description: "Routines for populating tuple fields. Accessible via shared instance [$source EL_MODULE_TUPLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 10:16:49 GMT (Tuesday 5th January 2021)"
	revision: "13"

class
	EL_TUPLE_ROUTINES

inherit
	ANY

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

	EL_STRING_8_CONSTANTS

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
			list: EL_SPLIT_STRING_LIST [STRING_GENERAL]; str_8: STRING; ref_item: ANY
			type_convertible: BOOLEAN; list_item: STRING_GENERAL; s: EL_STRING_8_ROUTINES
		do
			tuple_type := tuple.generating_type
			csv_list_type_id := {ISE_RUNTIME}.dynamic_type (csv_list)
			if csv_list.is_string_8 then
				create {EL_SPLIT_STRING_8_LIST} list.make (csv_list.as_string_8, Comma)
			else
				create {EL_SPLIT_STRING_32_LIST} list.make (csv_list.as_string_32, Comma)
			end
			if left_adjusted then
				list.enable_left_adjust
			end
			from list.start until list.index > tuple.count or list.after loop
				list_item := list.item (False)
				item_type := tuple_type.generic_parameter_type (list.index)
				type_id := item_type.type_id
				ref_item := Void; type_convertible := True
				inspect tuple.item_code (list.index)
					when {TUPLE}.Reference_code then
						if csv_list_type_id = type_id then
							ref_item := list_item.twin
						elseif attached new_item (type_id, list_item) as new then
							ref_item := new
						else
							type_convertible := False
						end
				else
					if list_item.is_valid_as_string_8 then
						str_8 := list_item.to_string_8
						-- Try converting to basic type
						if s.is_convertible (str_8, item_type) then
							tuple.put (s.to_type (str_8, item_type), list.index)
						else
							type_convertible := False
						end
					else
						type_convertible := False
					end
				end
				if attached ref_item as l_item  then
					tuple.put_reference (l_item, list.index)
				end
				check
					type_convertible: type_convertible
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
			end
		end

feature {NONE} -- Constants

	Comma: STRING = ","

end