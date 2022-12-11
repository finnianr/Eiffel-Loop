note
	description: "Reflected storable reference type table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-11 18:15:07 GMT (Sunday 11th December 2022)"
	revision: "12"

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
		local
			tuple_types: EL_TUPLE_TYPE_ARRAY
		do
			if field_conforms_to (type_id, Class_id.TUPLE) then
				create tuple_types.make_from_static (type_id)
--				TUPLE items must be expanded or strings
				Result := across tuple_types as type all
					type.item.is_expanded or else String_type_table.type_array.has (type.item.type_id)
				end
			else
				Result := conforming_type (type_id) > 0
			end
		end

end