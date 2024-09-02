note
	description: "Properties of field type in a reference object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-02 11:56:44 GMT (Monday 2nd September 2024)"
	revision: "7"

class
	EL_FIELD_TYPE_PROPERTIES

inherit
	EL_INTERNAL
		rename
			abstract_type as object_abstract_type,
			conforms_to as object_conforms_to,
			collection_item_type as collection_item_type_for_type,
			make as make_default,
			dynamic_type as object_dynamic_type,
			is_reference as is_abstract_type_a_reference,
			is_readable_string_32 as is_object_readable_string_32
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_index, a_dynamic_type: INTEGER)
		do
			index := a_index; dynamic_type := a_dynamic_type
			abstract_type := field_type_of_type (index, dynamic_type)
			static_type := field_static_type_of_type (index, dynamic_type)
			make_default
		end

feature -- Access

	abstract_type: INTEGER

	collection_item_type: INTEGER
		do
			Result := collection_item_type_for_type (static_type)
		end

	dynamic_type: INTEGER

	index: INTEGER

	static_type: INTEGER

	value_for (enclosing_object: ANY): detachable ANY
		-- reference value for field at `index' place in `enclosing_object'
		require
			is_reference: is_reference
		do
			if attached Once_reference_object as ro then
				ro.set_object (enclosing_object)
				Result := ro.reference_field (index)
			end
		end

feature -- Status query

	conforms_to (a_field_type: INTEGER): BOOLEAN
		do
			Result := field_conforms_to (static_type, a_field_type)
		end

	conforms_to_type (type: TYPE [ANY]): BOOLEAN
		do
			Result := conforms_to (type.type_id)
		end

	conforms_to_collection: BOOLEAN
		do
			Result := is_reference and then conforms_to (class_id.COLLECTION__ANY)
		end

	conforms_to_date_time: BOOLEAN
		do
			Result := is_reference and then conforms_to (class_id.DATE_TIME)
		end

	is_convertable_from_string: BOOLEAN
		do
			Result := is_type_convertable_from_string (abstract_type, static_type)
		end

	is_expanded: BOOLEAN
		do
			Result := abstract_type /= Reference_type
		end

	is_pointer: BOOLEAN
		do
			Result := abstract_type = Pointer_type
		end

	is_readable_string_8: BOOLEAN
		do
			if is_reference then
				Result := is_type_in_set (static_type, class_id.readable_string_8_types)
			end
		end

	is_readable_string_32: BOOLEAN
		do
			if is_reference then
				Result := is_type_in_set (static_type, class_id.readable_string_32_types)
			end
		end

	is_reference: BOOLEAN
		do
			Result := abstract_type = Reference_type
		end

	is_storable: BOOLEAN
		local
			type_id: INTEGER
		do
			type_id := static_type
			if is_storable_type (abstract_type, type_id) then
				Result := True

			elseif field_conforms_to (type_id, class_id.ARRAYED_LIST__ANY) then
				if Arrayed_list_factory.is_valid_type (type_id) then
					Result := is_storable_collection_type (type_id)
				end
			end
		end

	is_string_or_expanded: BOOLEAN
		do
			Result := is_string_or_expanded_type (abstract_type, static_type)
		end

	is_table: BOOLEAN
		do
			Result := is_table_type (abstract_type, static_type)
		end

	is_transient: BOOLEAN
		-- `True' if field has "note option: transient attribute end"
		do
			Result := is_field_transient_of_type (index, dynamic_type)
		end

feature {NONE} -- Constants

	Once_reference_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end
end