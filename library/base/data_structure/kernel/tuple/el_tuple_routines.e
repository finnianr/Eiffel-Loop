note
	description: "Routines accessible from once routine `Tuple' in [$source EL_MODULE_TUPLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 0:31:18 GMT (Friday 31st January 2020)"
	revision: "10"

class
	EL_TUPLE_ROUTINES

inherit
	ANY

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

	EL_MODULE_STRING_8

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
			tuple_type: TYPE [TUPLE]; item_type: TYPE [ANY]; type_id: INTEGER
			list: EL_SPLIT_STRING_LIST [STRING_GENERAL]; str_8: STRING; ref_item: ANY
			type_convertible: BOOLEAN; string_item: STRING_GENERAL
		do
			tuple_type := tuple.generating_type
			if csv_list.is_string_8 then
				create {EL_SPLIT_STRING_8_LIST} list.make (csv_list.to_string_8, Comma)
			else
				create {EL_SPLIT_STRING_32_LIST} list.make (csv_list.to_string_32, Comma)
			end
			if left_adjusted then
				list.enable_left_adjust
			end
			from list.start until list.index > tuple.count or list.after loop
				string_item := list.item (False)
				item_type := tuple_type.generic_parameter_type (list.index)
				type_id := item_type.type_id
				ref_item := Void; type_convertible := True
				inspect tuple.item_code (list.index)
					when {TUPLE}.Reference_code then
						if type_id = Class_id.ZSTRING then
							ref_item := create {ZSTRING}.make_from_general (string_item)

						elseif type_id = Class_id.STRING_8 and then string_item.is_string_8 then
							ref_item := create {STRING_8}.make_from_string (string_item.to_string_8)

						elseif type_id = Class_id.STRING_32 then
							ref_item := create {STRING_32}.make_from_string (string_item)

						elseif type_id = Class_id.EL_FILE_PATH then
							ref_item := create {EL_FILE_PATH}.make (string_item)

						elseif type_id = Class_id.EL_DIR_PATH then
							ref_item := create {EL_DIR_PATH}.make (string_item)
						else
							type_convertible := False
						end
				else
					if string_item.is_string_8 then
						str_8 := string_item.to_string_8
						-- Try converting to basic type
						if String_8.is_convertible (str_8, item_type) then
							tuple.put (String_8.to_type (str_8, item_type), list.index)
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

feature {NONE} -- Constants

	Comma: STRING = ","

end
