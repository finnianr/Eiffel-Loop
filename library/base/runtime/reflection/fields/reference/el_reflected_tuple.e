note
	description: "Reflected TUPLE that can be read from a string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-24 19:22:19 GMT (Friday 24th January 2020)"
	revision: "5"

class
	EL_REFLECTED_TUPLE

inherit
	EL_REFLECTED_REFERENCE [TUPLE]
		redefine
			is_initializeable,
			make, write, new_instance, reset,
			set_from_readable, set_from_string, to_string
		end

	EL_ZSTRING_CONSTANTS

	EL_STRING_32_CONSTANTS

	EL_STRING_8_CONSTANTS

create
	make

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: STRING)
		do
			make_reflected (a_object)
			create member_types.make_from_static (field_static_type (a_index))
			Precursor (a_object, a_index, a_name)
		end

feature -- Status query

	is_initializeable: BOOLEAN
		-- `True' when possible to create an initialized instance of the field
		do
			Result := across member_types as l_type all
				not l_type.item.is_expanded implies New_instance_table.has (l_type.item.type_id)
			end
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			initialize (a_object)
		end

	set_from_readable (a_object: EL_REFLECTIVE; reader: EL_READABLE)
		do
			if member_types.is_latin_1_representable then
				set_from_string (a_object, reader.read_string_8)
			else
				set_from_string (a_object, reader.read_string)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			list: EL_SPLIT_STRING_LIST [STRING_GENERAL]
		do
			if attached {ZSTRING} string as str_z then
				create {EL_SPLIT_ZSTRING_LIST} list.make (str_z, character_string (','))

			elseif attached {STRING_8} string as str_8 then
				create {EL_SPLIT_STRING_LIST [STRING_8]} list.make (str_8, character_string_8 (','))

			else
				create {EL_SPLIT_STRING_LIST [STRING_32]} list.make (string.to_string_32, character_string_32 (','))
			end
			list.enable_left_adjust
			set_from_list (a_object, list)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			write_tuple (value (a_object), writeable, once ", ")
		end

feature -- Conversion

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		local
			str: ZSTRING
		do
			str := String_pool.new_string
			write (a_object, str)
			if member_types.is_latin_1_representable then
				Result := str.to_latin_1
			else
				Result := str.twin
			end
			String_pool.recycle (str)
		end

feature {NONE} -- Implementation

	new_instance: TUPLE
		local
			i: INTEGER_32; l_type: TYPE [ANY]; has_reference: BOOLEAN
			l_types: like member_types
		do
			if attached {TUPLE} Eiffel.new_instance_of (type_id) as new_tuple then
				l_types := member_types
				from i := 1 until i > l_types.count loop
					l_type := l_types [i]
					if not l_type.is_expanded then
						if New_instance_table.has_key (l_type.type_id) then
							New_instance_table.found_item.apply
							new_tuple.put_reference (New_instance_table.found_item.last_result, i)
						end
						has_reference := True
					end
					i := i + 1
				end
				if has_reference then
					new_tuple.compare_objects
				end
				Result := new_tuple
			else
				create Result
			end
		end

	set_from_list (a_object: EL_REFLECTIVE; list: EL_SPLIT_STRING_LIST [STRING_GENERAL])
		local
			tuple: TUPLE; item: STRING_GENERAL
			i, l_count: INTEGER
		do
			tuple := value (a_object)
			l_count := tuple.count.min (list.count)
			from i := 1 until i > l_count loop
				list.go_i_th (i)
				item := list.item (False)
				inspect tuple.item_code (i)
					when {TUPLE}.Character_8_code then
						if not item.is_empty then
							tuple.put_character (item.item (1).to_character_8, i)
						end

					when {TUPLE}.Character_32_code then
						if not item.is_empty then
							tuple.put_character_32 (item.item (1), i)
						end

					when {TUPLE}.Boolean_code then
						if item.is_boolean then
							tuple.put_boolean (item.to_boolean, i)
						end

					when {TUPLE}.Integer_8_code then
						if item.is_integer_8 then
							tuple.put_integer_8 (item.to_integer_8, i)
						end

					when {TUPLE}.Integer_16_code then
						if item.is_integer_16 then
							tuple.put_integer_16 (item.to_integer_16, i)
						end

					when {TUPLE}.Integer_32_code then
						if item.is_integer_32 then
							tuple.put_integer (item.to_integer_32, i)
						end

					when {TUPLE}.Integer_64_code then
						if item.is_integer_64 then
							tuple.put_integer_64 (item.to_integer_64, i)
						end

					when {TUPLE}.Natural_8_code then
						if item.is_natural_8 then
							tuple.put_natural_8 (item.to_natural_8, i)
						end

					when {TUPLE}.Natural_16_code then
						if item.is_natural_16 then
							tuple.put_natural_16 (item.to_natural_16, i)
						end

					when {TUPLE}.Natural_32_code then
						if item.is_natural_32 then
							tuple.put_natural_32 (item.to_natural_32, i)
						end

					when {TUPLE}.Natural_64_code then
						if item.is_natural_64 then
							tuple.put_natural_64 (item.to_natural_64, i)
						end

					when {TUPLE}.Real_32_code then
						if item.is_real_32 then
							tuple.put_real_32 (item.to_real_32, i)
						end

					when {TUPLE}.Real_64_code then
						if item.is_real_64 then
							tuple.put_real_64 (item.to_real_64, i)
						end

					when {TUPLE}.Reference_code then
						if attached {STRING_GENERAL} tuple.reference_item (i) as str then
							str.keep_head (0); str.append (item)
						end
				else
				end
				i := i + 1
			end
		end

	write_tuple (tuple: TUPLE; writeable: EL_WRITEABLE; delimiter: STRING)
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				if i > 1 and then not delimiter.is_empty then
					writeable.write_string_8 (delimiter)
				end
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

	member_types: EL_TUPLE_TYPE_ARRAY
		-- types of tuple members

end
