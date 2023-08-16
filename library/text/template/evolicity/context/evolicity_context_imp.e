note
	description: "[
		A createable Evolicity context where you add variables in the following ways:
		
		* from a table of strings using `make_from_string_table'
		* from a table of referenceable object_table using `make_from_object_table'
		* Calling `put_variable' or `put_integer'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 14:03:06 GMT (Monday 31st July 2023)"
	revision: "7"

class
	EVOLICITY_CONTEXT_IMP

inherit
	ANY

	EVOLICITY_CONTEXT

create
	make, make_from_string_table, make_from_object_table

feature {NONE} -- Initialization

	make
			--
		do
			create object_table
			object_table.compare_objects
		end


	make_from_object_table (table: EL_STRING_8_TABLE [ANY])
			--
		do
			create object_table.make_equal (table.count)
			object_table.merge (table)
		end

	make_from_string_table (table: EL_STRING_8_TABLE [READABLE_STRING_GENERAL])

		do
			create object_table.make_equal (table.count)
			from table.start until table.after loop
				put_any (table.key_for_iteration, table.item_for_iteration)
				table.forth
			end
		end

feature {NONE} -- Internal attributes

	object_table: EL_STRING_8_TABLE [ANY]

end