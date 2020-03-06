note
	description: "Evolicity tuple context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-02 10:35:33 GMT (Monday 2nd March 2020)"
	revision: "3"

class
	EVOLICITY_TUPLE_CONTEXT

inherit
	EVOLICITY_CONTEXT_IMP
		rename
			make as make_context
		end

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	make (tuple: TUPLE; field_names: STRING)
		require
			enough_field_names: tuple.count = field_names.occurrences (',') + 1
		local
			name_list: EL_STRING_8_LIST; type, index: INTEGER
		do
			make_context
			type := Eiffel.dynamic_type (tuple)
			if Name_list_table.has_key (type) then
				name_list := Name_list_table.found_item
			else
				create name_list.make_with_separator (field_names, ',', True)
				Name_list_table.extend (name_list, type)
			end
			across name_list as name loop
				index := name.cursor_index
				inspect tuple.item_code (index)
					when {TUPLE}.Integer_32_code then
						put_integer (name.item, tuple.integer_32_item (index))
					when {TUPLE}.Natural_32_code then
						put_natural (name.item, tuple.natural_32_item (index))
					when {TUPLE}.Real_32_code then
						put_real (name.item, tuple.real_32_item (index))
					when {TUPLE}.Real_64_code then
						put_double (name.item, tuple.real_64_item (index))
					when {TUPLE}.Boolean_code then
						put_boolean (name.item, tuple.boolean_item (index))
					when {TUPLE}.Reference_code then
						put_variable (tuple.reference_item (index), name.item)
				else
				end
			end
		end

feature {NONE} -- Constants

	Name_list_table: HASH_TABLE [EL_STRING_8_LIST, INTEGER]
		once
			 create Result.make (3)
		end
end
