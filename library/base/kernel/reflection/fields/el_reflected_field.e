note
	description: "Manages attribute field for a class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:18:15 GMT (Monday 28th April 2025)"
	revision: "70"

deferred class
	EL_REFLECTED_FIELD

inherit
	EL_REFLECTED_FIELD_BASE
		redefine
			is_equal
		end

feature {EL_CLASS_META_DATA} -- Initialization

	make (object: ANY; a_index: INTEGER; a_name: IMMUTABLE_STRING_8)
		require
			reference_object: not object.generating_type.is_expanded
		do
			index := a_index; name := a_name; export_name := a_name
			object_type := {ISE_RUNTIME}.dynamic_type (object)
			type_id := field_static_type (index)
			type := Eiffel.type_of_type (type_id)
			post_make
		end

	post_make
		-- initialization after types have been set
		do
		end

feature -- Names

	class_name: IMMUTABLE_STRING_8
		do
			Result := type.name
		end

	export_name: IMMUTABLE_STRING_8

	name: IMMUTABLE_STRING_8

feature -- Access

	representation: detachable EL_FIELD_REPRESENTATION [like value, ANY]

	type: TYPE [ANY]

	type_id: INTEGER
		-- Static type of dynamic type `{ISE_RUNTIME}.field_static_type_of_type'

	type_info: EL_FIELD_TYPE_PROPERTIES
		do
			create Result.make (index, object_type)
		end

feature -- Access deferred

	abstract_type: INTEGER
		-- abstract type of field corresponding to `REFLECTOR_CONSTANTS' type constants
		deferred
		end

	address (object: ANY): POINTER
		require
			valid_type: valid_type (object)
		deferred
		end

	reference_value (object: ANY): ANY
		deferred
		end

	to_string (object: ANY): READABLE_STRING_GENERAL
		deferred
		end

	value (object: ANY): ANY
		require
			valid_type: valid_type (object)
		deferred
		end

feature -- Measurement

	size_of (object: ANY): INTEGER
		-- size of field object
		deferred
		end

feature -- Status query

	conforms_to_type (base_type_id: INTEGER): BOOLEAN
		require
			base_type_id_not_negative: base_type_id >= 0
		do
			Result := {ISE_RUNTIME}.type_conforms_to (type_id, {ISE_RUNTIME}.detachable_type (base_type_id))
		end

	has_representation: BOOLEAN
		do
			Result := attached representation
		end

	is_abstract: BOOLEAN
		-- `True' if `type' of field is not specific to one type, but is conforming t
		do
			Result := False
		end

	is_expanded: BOOLEAN
		deferred
		end

	is_initialized (object: ANY): BOOLEAN
		do
			Result := True
		end

	is_numeric_type: BOOLEAN
		-- `True' if `value' type conforms to `NUMERIC'
		do
			Result := False
		end

	is_storable_type: BOOLEAN
		-- is type storable using `EL_STORABLE' interface
		do
			Result := True
		end

	is_string_type: BOOLEAN
		-- `True' if `value' type conforms to `READABLE_STRING_GENERAL'
		do
			Result := False
		end

	is_type (a_type_id: INTEGER): BOOLEAN
		do
			Result := type_id = a_type_id
		end

	is_uninitialized (object: ANY): BOOLEAN
		do
			Result := not is_initialized (object)
		end

feature -- Contract Support

	valid_string (object: ANY; string: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `string' is valid argument for `set_from_string'
		do
			Result := True
		end

	valid_type (object: ANY): BOOLEAN
		-- `True' if `object' type is correct for this field
		do
			Result := {ISE_RUNTIME}.dynamic_type (object) = object_type
		end

feature -- Comparison

	are_equal (a_current, other: ANY): BOOLEAN
		deferred
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := object_type = other.object_type and then name ~ other.name
		end

feature -- Basic operations

	append_to_string (object: ANY; str: ZSTRING)
		deferred
		end

	initialize (object: ANY)
		require
			valid_type: valid_type (object)
		do
		end

	reset (object: ANY)
		require
			valid_type: valid_type (object)
		deferred
		end

	set (object: ANY; a_value: like value)
		require
			valid_type: valid_type (object)
		deferred
		end

	set_from_integer (object: ANY; a_value: INTEGER)
		deferred
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			set_from_readable (object, memory)
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		deferred
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		require
			valid_string: valid_string (object, string)
		deferred
		end

	set_from_utf_8 (object: ANY; utf_8: READABLE_STRING_8)
		deferred
		end

	write (object: ANY; writeable: EL_WRITABLE)
		deferred
		end

	write_field_hash (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			write_crc (crc)
			if attached representation as r then
				r.write_crc (crc)
			end
		end

	write_to_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			write (object, memory)
		end

feature -- Element change

	set_export_name (a_name: IMMUTABLE_STRING_8)
		do
			export_name := a_name
		end

	set_index (a_index: INTEGER)
		do
			index := a_index
		end

	set_representation (a_representation: like representation)
		require
			correct_type: a_representation.value_type ~ type
			not_default_reference_type: generating_type /~ {EL_REFLECTED_REFERENCE [ANY]}
		do
			representation := a_representation
		end

feature {NONE} -- Implementation

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			crc.add_string_8 (name)
			crc.add_string_8 (class_name)
		end

note
	descendants: "[
			EL_REFLECTED_FIELD*
				${EL_REFLECTED_REFERENCE [G]}
					${EL_REFLECTED_COLLECTION [G]}
					${EL_REFLECTED_TEMPORAL* [G -> ABSOLUTE]}
						${EL_REFLECTED_TIME}
						${EL_REFLECTED_DATE_TIME}
						${EL_REFLECTED_DATE}
					${EL_REFLECTED_TUPLE}
					${EL_REFLECTED_BOOLEAN_REF}
					${EL_REFLECTED_MANAGED_POINTER}
					${EL_REFLECTED_STORABLE}
					${EL_REFLECTED_REFERENCE_ANY}
					${EL_REFLECTED_HASHABLE_REFERENCE [H -> HASHABLE]}
						${EL_REFLECTED_STRING* [S -> READABLE_STRING_GENERAL create make end]}
							${EL_REFLECTED_STRING_8}
							${EL_REFLECTED_IMMUTABLE_STRING_8}
							${EL_REFLECTED_IMMUTABLE_STRING_32}
							${EL_REFLECTED_STRING_32}
							${EL_REFLECTED_URI [U -> EL_URI create make end]}
							${EL_REFLECTED_ZSTRING}
						${EL_REFLECTED_PATH}
					${EL_REFLECTED_MAKEABLE_FROM_STRING* [MAKEABLE -> EL_MAKEABLE_FROM_STRING [STRING_GENERAL]]}
						${EL_REFLECTED_MAKEABLE_FROM_STRING_8}
						${EL_REFLECTED_MAKEABLE_FROM_STRING_32}
						${EL_REFLECTED_MAKEABLE_FROM_ZSTRING}
				${EL_REFLECTED_EXPANDED_FIELD* [G]}
					${EL_REFLECTED_BOOLEAN}
					${EL_REFLECTED_NUMERIC_FIELD* [N -> NUMERIC]}
						${EL_REFLECTED_REAL_32}
						${EL_REFLECTED_INTEGER_FIELD* [N -> NUMERIC]}
							${EL_REFLECTED_INTEGER_8}
							${EL_REFLECTED_INTEGER_32}
							${EL_REFLECTED_INTEGER_64}
							${EL_REFLECTED_NATURAL_8}
							${EL_REFLECTED_NATURAL_16}
							${EL_REFLECTED_NATURAL_32}
							${EL_REFLECTED_NATURAL_64}
							${EL_REFLECTED_INTEGER_16}
						${EL_REFLECTED_REAL_64}
					${EL_REFLECTED_CHARACTER_8}
					${EL_REFLECTED_CHARACTER_32}
					${EL_REFLECTED_POINTER}
	]"
end