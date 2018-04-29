note
	description: "Manages attribute field for a class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-26 11:09:02 GMT (Thursday 26th April 2018)"
	revision: "9"

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
		end

	EL_REFLECTOR_CONSTANTS

	EL_MODULE_EIFFEL

	EL_REFLECTION_HANDLER

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: STRING)
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

feature -- Basic operations

	print_meta_data (a_object: EL_REFLECTIVE; lio: EL_LOGGABLE; i: INTEGER; last: BOOLEAN)
		local
			label: STRING
		do
			label := new_numbered_label (i); label.append (name)
			lio.put_labeled_string (label, class_name)
			if not last then
				lio.put_new_line
			end
		end

	reset (a_object: EL_REFLECTIVE)
		deferred
		end

	set (a_object: EL_REFLECTIVE; a_value: like value)
		deferred
		end

	initialize (a_object: EL_REFLECTIVE)
		do
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

feature {NONE} -- Constants

	Once_label: STRING
		once
			create Result.make_empty
		end
end
