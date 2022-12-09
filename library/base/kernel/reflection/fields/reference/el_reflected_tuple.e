note
	description: "Reflected field conforming to type [$source TUPLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 8:19:37 GMT (Friday 9th December 2022)"
	revision: "21"

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

	EL_MODULE_REUSEABLE

	EL_STRING_8_CONSTANTS

	EL_DOUBLE_MATH undefine is_equal end

	EL_SHARED_NEW_INSTANCE_TABLE

create
	make

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: STRING)
		do
			make_reflected (a_object)
			create member_types.make_from_static (field_static_type (a_index))
			factory_array := new_factory_array
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
			set: lists_match (csv_list, to_string (a_object))
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

	lists_match (csv_list_1, csv_list_2: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if lists match and taking account of DOUBLE approximations
		-- Example: 1.3 same as 1.3000000000002
		local
			list_1, list_2: EL_ZSTRING_LIST
			item_1, item_2: ZSTRING
		do
			create list_1.make_comma_split (csv_list_1)
			create list_2.make_comma_split (csv_list_2)
			Result := list_1.count = list_2.count
			if Result then
				across list_1 as list until not Result loop
					item_1 := list.item; item_2 := list_2 [list.cursor_index]
					if item_1.count = item_2.count then
						Result := item_1.same_string (item_2)

					elseif item_1.is_double and then item_2.is_double then
						Result := approximately_equal (item_1.to_double, item_2.to_double, 0.00000000001)
					else
						Result := False
					end
				end
			end
		end

	new_instance: TUPLE
		local
			i, i_final: INTEGER_32; has_reference: BOOLEAN
		do
			if attached {TUPLE} Eiffel.new_instance_of (type_id) as new_tuple
				and then attached factory_array as array
			then
				i_final := array.count
				from i := 0 until i = i_final loop
					if attached array [i] as l_factory then
						new_tuple.put_reference (l_factory.new_item, i + 1)
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

	new_factory_array: SPECIAL [detachable EL_FACTORY [ANY]]
		local
			i: INTEGER_32
		do
			create Result.make_filled (Void, member_types.count)
			if attached member_types as l_types then
				from i := 1 until i > l_types.count loop
					if attached l_types [i] as i_th and then not i_th.is_expanded then
						if attached factory_for_type (i_th.type_id) as item_factory then
							if item_factory = Default_factory and then New_instance_table.has (i_th.type_id) then
								Result [i - 1] := create {EL_AGENT_FACILITATED_FACTORY [ANY]}.make (i_th.type_id)
							else
								Result [i - 1] := item_factory.new_item_factory (i_th.type_id)
							end
						end
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	factory_array: like new_factory_array

feature {NONE} -- Constants

	Comma_space: STRING = ", "

	Comma_string: STRING = ","

end