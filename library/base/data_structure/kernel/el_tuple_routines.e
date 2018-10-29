note
	description: "Routines accessible from once routine `Tuple' in [$source EL_MODULE_TUPLE]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_TUPLE_ROUTINES

inherit
	EL_REFLECTOR_CONSTANTS

feature -- Basic operations

	fill (tuple: TUPLE; csv_list: STRING_GENERAL)
		do
			fill_adjusted (tuple, csv_list, True)
		end

	fill_adjusted (tuple: TUPLE; csv_list: STRING_GENERAL; left_adjusted: BOOLEAN)
		-- fill tuple with STRING items from comma-separated list `csv_list' of strings
		-- TUPLE may contain any of types STRING_8, STRING_32, ZSTRING
		-- items are left adjusted if `left_adjusted' is True
		local
			list: LIST [STRING_GENERAL]; general: STRING_GENERAL
			found: BOOLEAN; l_tuple_type: TYPE [TUPLE]; type_id: INTEGER
		do
			l_tuple_type := tuple.generating_type
			list := csv_list.split (',')
			from list.start until list.index > tuple.count or list.after loop
				type_id := l_tuple_type.generic_parameter_type (list.index).type_id
				found := True
				if type_id = String_z_type then
					general := create {ZSTRING}.make_from_general (list.item)
				elseif type_id = String_8_type then
					general := list.item.to_string_8
				elseif type_id = String_32_type then
					general := list.item.to_string_32
				else
					found := False
				end
				if found then
					if left_adjusted then
						general.left_adjust
					end
					tuple.put_reference (general, list.index)
				end
				list.forth
			end
		end

	to_string_8_list (tuple: TUPLE): EL_STRING_8_LIST
		do
			Result := tuple
		end

	to_string_32_list (tuple: TUPLE): EL_STRING_32_LIST
		do
			Result := tuple
		end

	to_zstring_list (tuple: TUPLE): EL_ZSTRING_LIST
		do
			Result := tuple
		end

end
