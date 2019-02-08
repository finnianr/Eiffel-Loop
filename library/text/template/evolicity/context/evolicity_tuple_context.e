note
	description: "Evolicity tuple context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-08 16:01:10 GMT (Friday 8th February 2019)"
	revision: "1"

class
	EVOLICITY_TUPLE_CONTEXT

inherit
	EVOLICITY_CONTEXT_IMP
		rename
			make as make_context
		end

	EL_MODULE_EIFFEL

	EL_REFLECTOR_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (tuple: TUPLE; field_names: STRING)
		require
			enough_field_names: tuple.count = field_names.occurrences (',') + 1
		local
			tuple_info: like Tuple_info_table.item; type, index: INTEGER
			field_type: TYPE [ANY]
		do
			make_context
			type := Eiffel.dynamic_type (tuple)
			if Tuple_info_table.has_key (type) then
				tuple_info := Tuple_info_table.found_item
			else
				create tuple_info
				tuple_info.field_types := create {EL_TUPLE_TYPE_ARRAY}.make_from_tuple (tuple)
				tuple_info.name_list := create {EL_STRING_8_LIST}.make_with_separator (field_names, ',', True)
				Tuple_info_table.extend (tuple_info, type)
			end
			across tuple_info.name_list as name loop
				index := name.cursor_index
				field_type := tuple_info.field_types [index]
				inspect Eiffel.abstract_type (field_type.type_id)
					when Integer_32_type then
						put_integer (name.item, tuple.integer_32_item (index))
					when Natural_32_type then
						put_natural (name.item, tuple.natural_32_item (index))
					when Real_32_type then
						put_real (name.item, tuple.real_32_item (index))
					when Real_64_type then
						put_double (name.item, tuple.real_64_item (index))
					when Boolean_type then
						put_boolean (name.item, tuple.boolean_item (index))
					when Reference_type then
						put_variable (tuple.reference_item (index), name.item)
				else end
			end
		end

feature {NONE} -- Constants

	Tuple_info_table: HASH_TABLE [TUPLE [field_types: EL_TUPLE_TYPE_ARRAY; name_list: EL_STRING_8_LIST], INTEGER]
		once
			 create Result.make (3)
		end
end
