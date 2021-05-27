note
	description: "A table index for assignment to a reflected field conforming to [$source HASHABLE]"
	notes: "[
		This is an experimental idea which in the end may not any better than existing TUPLE based
		indices. More thought required before finishing implemenation.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-24 14:02:33 GMT (Monday 24th May 2021)"
	revision: "1"

class
	ECD_INDEX_TABLE_REPRESENTATION [
		G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end, K -> detachable HASHABLE
	]

inherit
	EL_FIELD_REPRESENTATION [K, ECD_REFLECTIVE_INDEX_TABLE [G, K]]
		rename
			item as index_table
		end

feature -- Factory

	new_index (list: ECD_ARRAYED_LIST [G]; field: EL_REFLECTED_FIELD; n: INTEGER): like index_table
		do
			create Result.make (list, field, n)
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + value_type.name + " indexed with " + index_table.generator)
		end

end