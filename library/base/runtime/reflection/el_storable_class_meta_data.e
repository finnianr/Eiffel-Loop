note
	description: "Reflective meta data for classes that inherit [$source EL_REFLECTIVELY_SETTABLE_STORABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:05:42 GMT (Wednesday 21st February 2018)"
	revision: "4"

class
	EL_STORABLE_CLASS_META_DATA

inherit
	EL_CLASS_META_DATA
		redefine
			make, enclosing_object, Reference_type_table, Base_reference_types
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

feature {NONE} -- Internal attributes

	enclosing_object: EL_REFLECTIVELY_SETTABLE_STORABLE

feature {NONE} -- Constants

	Base_reference_types: ARRAY [INTEGER]
		local
			list: ARRAYED_LIST [INTEGER]
		once
			-- We check if fields conforms to `EL_STORABLE' first because some fields
			-- may conform to both `EL_STORABLE' and `EL_MAKEABLE_FROM_STRING_GENERAL'. For example: `EL_UUID'
			create list.make_from_array (<< Storable_type, Tuple_type >>)
			Precursor.do_all (agent list.extend)
			Result := list.to_array
		end

	Reference_type_table: EL_HASH_TABLE [TYPE [EL_REFLECTED_REFERENCE [ANY]], INTEGER_32]
		once
			create Result.make (<<
				[Tuple_type, {EL_REFLECTED_TUPLE}], [Storable_type, {EL_REFLECTED_STORABLE}]
			>>)
			Result.merge (Precursor)
		end

end
