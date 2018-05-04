note
	description: "Summary description for {EL_REFLECTED_TUPLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-26 11:47:11 GMT (Thursday 26th April 2018)"
	revision: "4"

class
	EL_REFLECTED_TUPLE

inherit
	EL_REFLECTED_READABLE [TUPLE]
		rename
			default_value as default_tuple
		redefine
			make, write, default_defined, initialize, initialize_default, reset
		end

create
	make

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: STRING)
		local
			l_type: TYPE [ANY]; i, count: INTEGER
		do
			make_reflected (a_object)
			l_type := Eiffel.type_of_type (field_static_type (a_index))
			count := l_type.generic_parameter_count
			create member_types.make_filled ({INTEGER}, 1, count)
			from i := 1 until i > count loop
				member_types [i] := l_type.generic_parameter_type (i)
				i := i + 1
			end
			Precursor (a_object, a_index, a_name)
		end

feature -- Basic operations

	initialize (a_object: EL_REFLECTIVE)
		do
			if attached {TUPLE} default_tuple as tuple then
				set (a_object, tuple.deep_twin)
			end
		end

	reset (a_object: EL_REFLECTIVE)
		local
			l_value: like value
		do
			l_value := value (a_object)
		end

	read (a_object: EL_REFLECTIVE; reader: EL_MEMORY_READER_WRITER)
		do
			read_tuple (value (a_object), reader)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			write_tuple (value (a_object), writeable)
		end

feature {NONE} -- Implementation

	read_tuple (tuple: TUPLE; reader: EL_MEMORY_READER_WRITER)
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				inspect tuple.item_code (i)
					when {TUPLE}.Character_8_code then
						tuple.put_character (reader.read_character_8, i)

					when {TUPLE}.Character_32_code then
						tuple.put_character_32 (reader.read_character_32, i)

					when {TUPLE}.Boolean_code then
						tuple.put_boolean (reader.read_boolean, i)

					when {TUPLE}.Integer_8_code then
						tuple.put_integer_8 (reader.read_integer_8, i)

					when {TUPLE}.Integer_16_code then
						tuple.put_integer_16 (reader.read_integer_16, i)

					when {TUPLE}.Integer_32_code then
						tuple.put_integer (reader.read_integer_32, i)

					when {TUPLE}.Integer_64_code then
						tuple.put_integer_64 (reader.read_integer_64, i)

					when {TUPLE}.Natural_8_code then
						tuple.put_natural_8 (reader.read_natural_8, i)

					when {TUPLE}.Natural_16_code then
						tuple.put_natural_16 (reader.read_natural_16, i)

					when {TUPLE}.Natural_32_code then
						tuple.put_natural_32 (reader.read_natural_32, i)

					when {TUPLE}.Natural_64_code then
						tuple.put_natural_64 (reader.read_natural_64, i)

					when {TUPLE}.Real_32_code then
						tuple.put_real_32 (reader.read_real_32, i)

					when {TUPLE}.Real_64_code then
						tuple.put_real_64 (reader.read_real_64, i)

					when {TUPLE}.Reference_code then
						if attached {STRING_GENERAL} tuple.reference_item (i) as str then
							if attached {ZSTRING} str then
								tuple.put_reference (reader.read_string, i)
							elseif attached {STRING} str then
								tuple.put_reference (reader.read_string_8, i)
							elseif attached {STRING_32} str then
								tuple.put_reference (reader.read_string_32, i)
							end
						end
				else
				end
				i := i + 1
			end
		end

	initialize_default
		local
			i: INTEGER_32; l_type: TYPE [ANY]; has_reference: BOOLEAN
			l_types: like member_types
		do
			if attached {TUPLE} Eiffel.new_instance_of (type_id) as new_tuple then
				l_types := member_types
				from i := 1 until i > l_types.count loop
					l_type := l_types [i]
					if not l_type.is_expanded then
						if Default_strings.has_key (l_type.type_id) then
							new_tuple.put_reference (Default_strings.found_item.twin, i)
						end
						has_reference := True
					end
					i := i + 1
				end
				if has_reference then
					new_tuple.compare_objects
				end
				default_tuple := new_tuple
			end
		end

	write_tuple (tuple: TUPLE; writeable: EL_WRITEABLE)
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				inspect tuple.item_code (i)
					when {TUPLE}.Character_8_code then
						writeable.write_character_8 (tuple.character_8_item (i))

					when {TUPLE}.Character_32_code then
						writeable.write_character_32 (tuple.character_32_item (i))

					when {TUPLE}.Boolean_code then
						writeable.write_boolean (tuple.boolean_item (i))

					when {TUPLE}.Integer_8_code then
						writeable.write_integer_8 (tuple.integer_8_item (i))

					when {TUPLE}.Integer_16_code then
						writeable.write_integer_16 (tuple.integer_16_item (i))

					when {TUPLE}.Integer_32_code then
						writeable.write_integer_32 (tuple.integer_32_item (i))

					when {TUPLE}.Integer_64_code then
						writeable.write_integer_64 (tuple.integer_64_item (i))

					when {TUPLE}.Natural_8_code then
						writeable.write_natural_8 (tuple.natural_8_item (i))

					when {TUPLE}.Natural_16_code then
						writeable.write_natural_16 (tuple.natural_16_item (i))

					when {TUPLE}.Natural_32_code then
						writeable.write_natural_32 (tuple.natural_32_item (i))

					when {TUPLE}.Natural_64_code then
						writeable.write_natural_64 (tuple.natural_64_item (i))

					when {TUPLE}.Real_32_code then
						writeable.write_real_32 (tuple.real_32_item (i))

					when {TUPLE}.Real_64_code then
						writeable.write_real_64 (tuple.real_64_item (i))

					when {TUPLE}.Reference_code then
						if attached {READABLE_STRING_GENERAL} tuple.reference_item (i) as str then
							writeable.write_string_general (str)
						end
				else
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	member_types: ARRAY [TYPE [ANY]]
		-- types of tuple members

feature {NONE} -- Constants

	Default_defined: BOOLEAN = True

	Default_strings: EL_OBJECTS_BY_TYPE
		once
			create Result.make_from_array (<< Empty_string, Empty_string_8, Empty_string_32 >>)
		end

end
