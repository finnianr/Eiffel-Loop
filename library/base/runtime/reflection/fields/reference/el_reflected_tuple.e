note
	description: "Reflected TUPLE that can be read from a string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 10:26:09 GMT (Monday 3rd May 2021)"
	revision: "11"

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

	EL_STRING_8_CONSTANTS

	EL_MODULE_TUPLE

	EL_MODULE_CONVERT_STRING

create
	make

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: STRING)
		do
			make_reflected (a_object)
			create member_types.make_from_static (field_static_type (a_index))
			Precursor (a_object, a_index, a_name)
		end

feature -- Access

	member_types: EL_TUPLE_TYPE_ARRAY
		-- types of tuple members

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

	set_from_string (a_object: EL_REFLECTIVE; csv_list: READABLE_STRING_GENERAL)
		require else
			valid_comma_count: (csv_list.occurrences (',') + 1) = member_types.count
		do
			if attached value (a_object) as l_tuple then
				Convert_string.fill_tuple (l_tuple, csv_list, True)
			end
		ensure then
			set: csv_list.same_string (to_string (a_object))
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			if attached value (a_object) as l_tuple then
				Tuple.write (l_tuple, writeable, Comma_space)
			end
		end

feature -- Conversion

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached value (a_object) as l_tuple and then attached String_pool.reuseable_item as str then
				Tuple.write (l_tuple, str, Comma_space)
				if member_types.is_latin_1_representable then
					Result := str.to_latin_1
				else
					Result := str.twin
				end
				String_pool.recycle (str)
			end
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

feature {NONE} -- Constants

	Comma_space: STRING = ", "

	Comma_string: STRING = ","

end