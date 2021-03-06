note
	description: "Manages attribute field for a class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-29 9:08:22 GMT (Saturday 29th May 2021)"
	revision: "33"

deferred class
	EL_REFLECTED_FIELD

inherit
	REFLECTED_REFERENCE_OBJECT
		rename
			make as make_reflected,
			is_expanded as is_current_expanded,
			class_name as object_class_name
		export
			{NONE} all
		redefine
			is_equal, enclosing_object
		end

	EL_NAMEABLE [STRING] undefine is_equal end

	EL_REFLECTION_CONSTANTS undefine is_equal end

	EL_REFLECTION_HANDLER undefine is_equal end

	EL_MODULE_EIFFEL

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: like enclosing_object; a_index: INTEGER; a_name: STRING)
		do
			make_reflected (a_object)
			index := a_index; name := a_name
			export_name := a_object.export_name (a_name, True)
			type_id := field_static_type (index)
			type := Eiffel.type_of_type (type_id)
		end

feature -- Access

	category_id: INTEGER
		-- abstract type of field corresponding to `{TUPLE}.XX_code'
		-- eg. `{TUPLE}.reference_code'
		do
			Result := field_type (index)
		end

	class_name: IMMUTABLE_STRING_8
		do
			Result := type.name
		end

	export_name: STRING

	index: INTEGER

	name: STRING

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

	value (a_object: EL_REFLECTIVE): ANY
		deferred
		end

feature -- Status query

	conforms_to_type (base_type_id: INTEGER): BOOLEAN
		do
			Result := field_conforms_to (type_id, base_type_id)
		end

	is_expanded: BOOLEAN
		deferred
		end

	is_initialized (a_object: EL_REFLECTIVE): BOOLEAN
		do
			Result := True
		end

	is_uninitialized (a_object: EL_REFLECTIVE): BOOLEAN
		do
			Result := not is_initialized (a_object)
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

	set_from_command_line (a_object: EL_REFLECTIVE; args: EL_COMMAND_LINE_ARGUMENTS)
		do
			if args.has_value (name) then
				set_from_string (a_object, args.value (name))
			end
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
		deferred
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
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

	set_index (a_index: like index)
		do
			index := a_index
		end

feature -- Element change

	set_representation (a_representation: like representation)
		require
			correct_type: a_representation.value_type ~ type
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
					[$source EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT]
					[$source EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT]
					[$source EL_REFLECTED_COLLECTION] [G]
					[$source EL_REFLECTED_STRING]* [S -> [$source STRING_GENERAL]]
						[$source EL_REFLECTED_ZSTRING]
							[$source EL_REFLECTED_MEMBER_ZSTRING]
						[$source EL_REFLECTED_STRING_8]
							[$source EL_REFLECTED_MEMBER_STRING_8]
						[$source EL_REFLECTED_STRING_32]
							[$source EL_REFLECTED_MEMBER_STRING_32]
						[$source EL_REFLECTED_URI]
						[$source EL_REFLECTED_MEMBER_STRING]* [S -> [$source STRING_GENERAL]]
							[$source EL_REFLECTED_MEMBER_ZSTRING]
							[$source EL_REFLECTED_MEMBER_STRING_8]
							[$source EL_REFLECTED_MEMBER_STRING_32]
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