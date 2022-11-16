note
	description: "Reflected storable reference type table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_REFLECTED_STORABLE_REFERENCE_TYPE_TABLE

inherit
	EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY]]
		rename
			make as make_table
		redefine
			has_conforming
		end

	EL_REFLECTION_CONSTANTS
		undefine
			is_equal, copy, default_create
		end

	EL_SHARED_CLASS_ID

create
	make

feature {NONE} -- Initialization

	make
		do
 			make_table (<<
				{EL_REFLECTED_STORABLE}, {EL_REFLECTED_BOOLEAN_REF}, {EL_REFLECTED_MANAGED_POINTER},
				{EL_REFLECTED_DATE}, {EL_REFLECTED_DATE_TIME}, {EL_REFLECTED_TIME}
			>>)
		end

feature -- Status query

	has_conforming (type_id: INTEGER): BOOLEAN
		do
			if field_conforms_to (type_id, Class_id.TUPLE) then
				Result := tuple_items_are_expanded_or_string_types (type_of_type (type_id))
			else
				Result := conforming_type (type_id) > 0
			end
		end

feature {NONE} -- Implementation

	tuple_items_are_expanded_or_string_types (type: TYPE [ANY]): BOOLEAN
		local
			i, parameter_count: INTEGER_32; member_type: TYPE [ANY]
		do
			Result := True
			parameter_count := type.generic_parameter_count
			from i := 1 until not Result or else i > parameter_count loop
				member_type := type.generic_parameter_type (i)
				if not member_type.is_expanded then
					Result := String_type_table.type_array.has (member_type.type_id)
				end
				i := i + 1
			end
		end

end