note
	description: "Manages attribute field for a class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-17 16:16:06 GMT (Monday 17th July 2023)"
	revision: "56"

deferred class
	EL_REFLECTED_FIELD

inherit
	REFLECTED_REFERENCE_OBJECT
		rename
			make as make_reflected,
			is_expanded as is_current_expanded,
			class_name as object_class_name,
			physical_size as object_physical_size,
			deep_physical_size as deep_object_physical_size
		export
			{NONE} all
		redefine
			is_equal, enclosing_object
		end

	EL_NAMEABLE [STRING] undefine is_equal end

	EL_REFLECTION_CONSTANTS

	EL_REFLECTION_HANDLER

	EL_MODULE_EIFFEL

	EL_SHARED_IMMUTABLE_8_MANAGER

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: like enclosing_object; a_index: INTEGER; a_name: STRING)
		do
			make_reflected (a_object)
			index := a_index; name := a_name
			type_id := field_static_type (index)
			type := Eiffel.type_of_type (type_id)
			export_name := Immutable_8.new_substring (a_name.area, 0, a_name.count)
		end

feature -- Names

	category_id: INTEGER
		-- abstract type of field corresponding to `REFLECTOR_CONSTANTS' type constants
		do
			Result := field_type (index)
		end

	class_name: IMMUTABLE_STRING_8
		do
			Result := type.name
		end

	export_name: IMMUTABLE_STRING_8

	name: STRING

feature -- Access

	address (a_object: EL_REFLECTIVE): POINTER
		deferred
		end

	index: INTEGER

	reference_value (a_object: EL_REFLECTIVE): ANY
		deferred
		end

	representation: detachable EL_FIELD_REPRESENTATION [like value, ANY]

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		deferred
		end

	type: TYPE [ANY]

	type_id: INTEGER
		-- generating type

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		deferred
		end

	value (a_object: EL_REFLECTIVE): ANY
		deferred
		end

feature -- Status query

	conforms_to_type (base_type_id: INTEGER): BOOLEAN
		do
			Result := field_conforms_to (type_id, base_type_id)
		end

	has_representation: BOOLEAN
		do
			Result := attached representation
		end

	is_abstract: BOOLEAN
		-- `True' if field type is deferred
		do
			Result := False
		end

	is_expanded: BOOLEAN
		deferred
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

	is_initialized (a_object: EL_REFLECTIVE): BOOLEAN
		do
			Result := True
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

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		deferred
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := name ~ other.name
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		deferred
		end

	initialize (a_object: EL_REFLECTIVE)
		do
		end

	reset (a_object: EL_REFLECTIVE)
		deferred
		end

	set (a_object: EL_REFLECTIVE; a_value: like value)
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

feature {EL_REFLECTION_HANDLER} -- Internal attributes

	enclosing_object: separate EL_REFLECTIVE
		-- Enclosing object containing `object' or a reference to `object.

feature {NONE} -- Constants

	Buffer_8: EL_STRING_8_BUFFER
		once
			create Result
		end

	Buffer_32: EL_STRING_32_BUFFER
		once
			create Result
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