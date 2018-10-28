note
	description: "Evolicity eiffel context with reflectively created `getter_function_table'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 12:45:31 GMT (Sunday 28th October 2018)"
	revision: "1"

deferred class
	EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT

inherit
	EVOLICITY_EIFFEL_CONTEXT

	EVOLICITY_REFLECTIVE_CONTEXT

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
		local
			table: EL_REFLECTED_FIELD_TABLE; name: ZSTRING
		do
			table := meta_data_by_type.item (current_reflective).field_table
			create Result.make_equal (table.count)
			from table.start until table.after loop
				name := table.key_for_iteration
				Result [name] := agent get_field_value (table.item_for_iteration)
				table.forth
			end
		end
end
