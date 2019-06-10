note
	description: "Reflective meta data for classes that inherit [$source EL_REFLECTIVELY_SETTABLE_STORABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 20:34:43 GMT (Monday 10th June 2019)"
	revision: "7"

class
	EL_STORABLE_CLASS_META_DATA

inherit
	EL_CLASS_META_DATA
		redefine
			make, enclosing_object, Reference_type_tables
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

	Storable_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY], ANY]
		once
			create Result.make (<<
				[Storable_type, {EL_REFLECTED_STORABLE}],
				[Tuple_type, {EL_REFLECTED_TUPLE}]
			>>)
		end

	Reference_type_tables: ARRAY [EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY], ANY]]
		once
			Result := <<
--				We check if fields conforms to `EL_STORABLE' first because some fields
--				may conform to both `EL_STORABLE' and `EL_MAKEABLE_FROM_STRING_GENERAL'. For example: `EL_UUID'
				Storable_type_table,
				String_convertable_type_table,
				String_collection_type_table,
				Numeric_collection_type_table,
				Other_collection_type_table
			>>
		end
end
