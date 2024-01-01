note
	description: "Manages attribute field for a class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 10:33:00 GMT (Monday 1st January 2024)"
	revision: "61"

deferred class
	EL_REFLECTED_FIELD

inherit
	EL_REFLECTED_FIELD_IMPLEMENTATION
		redefine
			is_equal
		end

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: IMMUTABLE_STRING_8)
		require
			reference_object: not a_object.generating_type.is_expanded
		do
			index := a_index; name := a_name; export_name := a_name
			object_type := {ISE_RUNTIME}.dynamic_type (a_object)
			type_id := field_static_type (index)
			type := Eiffel.type_of_type (type_id)
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

	address (a_object: EL_REFLECTIVE): POINTER
		require
			valid_type: valid_type (a_object)
		deferred
		end

	reference_value (a_object: EL_REFLECTIVE): ANY
		deferred
		end

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		deferred
		end

	value (a_object: EL_REFLECTIVE): ANY
		require
			valid_type: valid_type (a_object)
		deferred
		end

feature -- Measurement

	size_of (a_object: EL_REFLECTIVE): INTEGER
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

	is_initialized (a_object: EL_REFLECTIVE): BOOLEAN
		do
			Result := True
		end

	is_storable_type: BOOLEAN
		-- is type storable using `EL_STORABLE' interface
		do
			Result := True
		end

	is_type (a_type_id: INTEGER): BOOLEAN
		do
			Result := type_id = a_type_id
		end

	is_uninitialized (a_object: EL_REFLECTIVE): BOOLEAN
		do
			Result := not is_initialized (a_object)
		end

feature -- Contract Support

	valid_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `string' is valid argument for `set_from_string'
		do
			Result := True
		end

	valid_type (a_object: EL_REFLECTIVE): BOOLEAN
		-- `True' if `a_object' type is correct for this field
		do
			Result := {ISE_RUNTIME}.dynamic_type (a_object) = object_type
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		deferred
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := object_type = other.object_type and then name ~ other.name
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		deferred
		end

	initialize (a_object: EL_REFLECTIVE)
		require
			valid_type: valid_type (a_object)
		do
		end

	reset (a_object: EL_REFLECTIVE)
		require
			valid_type: valid_type (a_object)
		deferred
		end

	set (a_object: EL_REFLECTIVE; a_value: like value)
		require
			valid_type: valid_type (a_object)
		deferred
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		deferred
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			set_from_readable (a_object, memory)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		deferred
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		require
			valid_string: valid_string (a_object, string)
		deferred
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		deferred
		end

	write_field_hash (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			write_crc (crc)
			if attached representation as r then
				r.write_crc (crc)
			end
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			write (a_object, memory)
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
				[$source EL_REFLECTED_REFERENCE] [G]
					[$source EL_REFLECTED_STORABLE]
					[$source EL_REFLECTED_TUPLE]
					[$source EL_REFLECTED_BOOLEAN_REF]
					[$source EL_REFLECTED_DATE]
					[$source EL_REFLECTED_TIME]
					[$source EL_REFLECTED_DATE_TIME]
					[$source EL_REFLECTED_PATH]
					[$source EL_REFLECTED_MAKEABLE_FROM_STRING]* [MAKEABLE -> [$source EL_MAKEABLE_FROM_STRING [STRING_GENERAL]]]
						[$source EL_REFLECTED_MAKEABLE_FROM_ZSTRING]
						[$source EL_REFLECTED_MAKEABLE_FROM_STRING_8]
						[$source EL_REFLECTED_MAKEABLE_FROM_STRING_32]
					[$source EL_REFLECTED_COLLECTION] [G]
					[$source EL_REFLECTED_STRING]* [S -> [$source STRING_GENERAL]]
						[$source EL_REFLECTED_ZSTRING]
						[$source EL_REFLECTED_STRING_8]
						[$source EL_REFLECTED_STRING_32]
						[$source EL_REFLECTED_URI]
				[$source EL_REFLECTED_EXPANDED_FIELD]* [G]
					[$source EL_REFLECTED_BOOLEAN]
					[$source EL_REFLECTED_CHARACTER_32]
					[$source EL_REFLECTED_POINTER]
					[$source EL_REFLECTED_CHARACTER_8]
					[$source EL_REFLECTED_NUMERIC_FIELD]* [N -> [$source NUMERIC]]
						[$source EL_REFLECTED_REAL_32]
						[$source EL_REFLECTED_INTEGER_32]
						[$source EL_REFLECTED_INTEGER_8]
						[$source EL_REFLECTED_INTEGER_16]
						[$source EL_REFLECTED_INTEGER_64]
						[$source EL_REFLECTED_NATURAL_8]
						[$source EL_REFLECTED_NATURAL_16]
						[$source EL_REFLECTED_NATURAL_32]
						[$source EL_REFLECTED_NATURAL_64]
						[$source EL_REFLECTED_REAL_64]

	]"
end