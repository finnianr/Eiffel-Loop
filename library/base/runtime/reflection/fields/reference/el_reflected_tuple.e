note
	description: "Reflected field conforming to type [$source TUPLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-17 18:01:55 GMT (Wednesday 17th November 2021)"
	revision: "15"

class
	EL_REFLECTED_TUPLE

inherit
	EL_REFLECTED_REFERENCE [TUPLE]
		redefine
			append_to_string, is_initializeable,
			make, write, new_instance, reset,
			set_from_memory, set_from_readable, set_from_string, to_string,
			write_to_memory
		end

	EL_MODULE_TUPLE

	EL_MODULE_CONVERT_STRING

	EL_MODULE_REUSABLE

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

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			write (a_object, str)
		end

	reset (a_object: EL_REFLECTIVE)
		do
			initialize (a_object)
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			Tuple.read (value (a_object), memory)
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

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as l_tuple then
				Tuple.write (l_tuple, memory, Empty_string_8)
			end
		end

feature -- Conversion

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached value (a_object) as l_tuple then
				across Reuseable.string as reuse loop
					if attached reuse.item as str then
						Tuple.write (l_tuple, str, Comma_space)
						if member_types.is_latin_1_representable then
							Result := str.to_latin_1
						else
							Result := str.twin
						end
					end
				end
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