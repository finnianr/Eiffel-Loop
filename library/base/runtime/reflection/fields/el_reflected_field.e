note
	description: "Manages attribute field for a class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-22 16:48:35 GMT (Tuesday 22nd December 2020)"
	revision: "23"

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

			type := field_type (index)
			type_id := field_static_type (index)
		end

feature -- Access

	class_name: STRING
		do
			Result := Eiffel.type_of_type (type_id).name
		end

	export_name: STRING

	index: INTEGER

	name: STRING

	reference_value (a_object: EL_REFLECTIVE): ANY
		deferred
		end

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		deferred
		end

	type: INTEGER
		-- abstract type

	type_id: INTEGER
		-- generating type

	value (a_object: EL_REFLECTIVE): ANY
		deferred
		end

feature -- Status query

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

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		deferred
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		deferred
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		deferred
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			crc.add_string_8 (name)
			crc.add_string_8 (Eiffel.type_of_type (type_id).name)
		end

feature -- Element change

	set_index (a_index: like index)
		do
			index := a_index
		end

feature {NONE} -- Implementation

	new_numbered_label (i: INTEGER): STRING
		do
			Result := Once_label
			Result.wipe_out
			if i < 10 then
				Result.append_character (' ')
			end
			Result.append_integer (i); Result.append (once ". ")
		end

feature {EL_REFLECTION_HANDLER} -- Internal attributes

	enclosing_object: separate EL_REFLECTIVE
			-- Enclosing object containing `object' or a reference to `object.

feature {NONE} -- Constants

	Once_label: STRING
		once
			create Result.make_empty
		end

note
	descendants: "[
			EL_REFLECTED_FIELD*
				[$source EL_REFLECTED_EXPANDED_FIELD]*
					[$source EL_REFLECTED_CHARACTER_8]
					[$source EL_REFLECTED_BOOLEAN]
					[$source EL_REFLECTED_POINTER]
					[$source EL_REFLECTED_CHARACTER_32]
					[$source EL_REFLECTED_NUMERIC_FIELD]*
						[$source EL_REFLECTED_INTEGER_8]
						[$source EL_REFLECTED_INTEGER_16]
						[$source EL_REFLECTED_INTEGER_32]
						[$source EL_REFLECTED_INTEGER_64]
						[$source EL_REFLECTED_NATURAL_8]
						[$source EL_REFLECTED_NATURAL_16]
						[$source EL_REFLECTED_NATURAL_32]
						[$source EL_REFLECTED_NATURAL_64]
						[$source EL_REFLECTED_REAL_32]
						[$source EL_REFLECTED_REAL_64]
				[$source EL_REFLECTED_REFERENCE]
					[$source EL_REFLECTED_PATH]
					[$source EL_REFLECTED_READABLE]*
						[$source EL_REFLECTED_STORABLE]
						[$source EL_REFLECTED_DATE_TIME]
						[$source EL_REFLECTED_STORABLE_TUPLE]
					[$source EL_REFLECTED_TUPLE]
						[$source EL_REFLECTED_STORABLE_TUPLE]
					[$source EL_REFLECTED_BOOLEAN_REF]
					[$source EL_REFLECTED_MAKEABLE_FROM_STRING]*
						[$source EL_REFLECTED_MAKEABLE_FROM_ZSTRING]
						[$source EL_REFLECTED_MAKEABLE_FROM_STRING_8]
						[$source EL_REFLECTED_MAKEABLE_FROM_STRING_32]
					[$source EL_REFLECTED_COLLECTION]
					[$source EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT]
					[$source EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT]
					[$source EL_REFLECTED_STRING]*
						[$source EL_REFLECTED_ZSTRING]
						[$source EL_REFLECTED_STRING_8]
						[$source EL_REFLECTED_STRING_32]
	]"

end