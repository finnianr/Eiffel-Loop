note
	description: "Reflected storable reference type table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-12 8:48:03 GMT (Wednesday 12th June 2019)"
	revision: "2"

class
	EL_REFLECTED_STORABLE_REFERENCE_TYPE_TABLE

inherit
	EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY], ANY]
		rename
			make as make_table
		redefine
			has_conforming
		end

	EL_REFLECTOR_CONSTANTS
		undefine
			is_equal, copy, default_create
		end

create
	make

feature {NONE} -- Initialization

	make
		do
 			make_table (<<
				[Storable_type,		{EL_REFLECTED_STORABLE}],
				[Boolean_ref_type,	{EL_REFLECTED_BOOLEAN_REF}],
				[Date_time_type,		{EL_REFLECTED_DATE_TIME}],
				[Tuple_type,			{EL_REFLECTED_STORABLE_TUPLE}]
			>>)
		end

feature -- Status query

	has_conforming (type_id: INTEGER): BOOLEAN
		do
			if field_conforms_to (type_id, Tuple_type) then
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
