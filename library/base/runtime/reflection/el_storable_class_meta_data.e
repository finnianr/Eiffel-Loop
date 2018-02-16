note
	description: "Reflective meta data for classes that inherit `EL_REFLECTIVELY_SETTABLE_STORABLE'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-23 12:58:07 GMT (Tuesday 23rd January 2018)"
	revision: "3"

class
	EL_STORABLE_CLASS_META_DATA

inherit
	EL_CLASS_META_DATA
		redefine
			make, enclosing_object, reference_type_id, Reference_type_table
		end

create
	make

feature {NONE} -- Initialization

	make (a_enclosing_object: like enclosing_object)
		do
			Precursor (a_enclosing_object)
			a_enclosing_object.adjust_field_order (field_array)
		end

feature -- Status query

	same_data_structure (a_field_hash: NATURAL): BOOLEAN
		-- `True' if order, type and names of fields are unchanged
		do
			Result := field_array.field_hash = a_field_hash
		end

feature {NONE} -- Implementation

	reference_type_id (index: INTEGER_32): INTEGER_32
			-- set reference fields of `type' with `new_object' taking a exported name
		do
			-- We check if fields conforms to `EL_STORABLE' before calling `Precursor' because some fields
			-- may conform to both `EL_STORABLE' and `EL_MAKEABLE_FROM_STRING'. For example: `EL_UUID'

			Result := field_static_type (index)
			if field_conforms_to (Result, Storable_type) then
				Result := Storable_type
			elseif field_conforms_to (Result, Tuple_type) then
				Result := Tuple_type
			else
				Result := 0
			end
			if Result = 0 then
				Result := Precursor (index)
			end
		end

feature {NONE} -- Internal attributes

	enclosing_object: EL_REFLECTIVELY_SETTABLE_STORABLE

feature {NONE} -- Constants

	Reference_type_table: EL_HASH_TABLE [TYPE [EL_REFLECTED_REFERENCE], INTEGER_32]
		once
			create Result.make (<<
				[Tuple_type, {EL_REFLECTED_TUPLE}], [Storable_type, {EL_REFLECTED_STORABLE}]
			>>)
			Result.merge (Precursor)
		end

end
