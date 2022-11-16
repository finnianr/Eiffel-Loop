note
	description: "A table index for assignment to a reflected field conforming to [$source HASHABLE]"
	notes: "[
		This is an experimental idea which in the end may not any better than existing TUPLE based
		indices. More thought required before finishing implemenation.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

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

	new_index (list: ECD_ARRAYED_LIST [G]; field: EL_REFLECTED_FIELD): like index_table
		do
			create Result.make (list, field)
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + value_type.name + " indexed with " + index_table.generator)
		end

end