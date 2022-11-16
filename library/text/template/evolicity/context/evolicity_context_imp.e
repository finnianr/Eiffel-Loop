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
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "6"

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


	make_from_object_table (table: HASH_TABLE [ANY, STRING])
			--
		do
			create object_table.make_equal (table.capacity)
			object_table.merge (table)
		end

	make_from_string_table (table: HASH_TABLE [READABLE_STRING_GENERAL, STRING])

		do
			create object_table.make_equal (table.capacity)
			from table.start until table.after loop
				put_variable (table.item_for_iteration, table.key_for_iteration)
				table.forth
			end
		end

feature {NONE} -- Internal attributes

	object_table: EVOLICITY_OBJECT_TABLE [ANY]

end