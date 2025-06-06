note
	description: "Reflected field conforming to type ${TUPLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:23:57 GMT (Monday 28th April 2025)"
	revision: "46"

class
	EL_REFLECTED_TUPLE

inherit
	EL_REFLECTED_REFERENCE [TUPLE]
		redefine
			is_initializeable, is_abstract, is_storable_type,
			post_make, write, new_instance, reset,
			set_from_memory, set_from_readable, set_from_string, to_string,
			write_crc, write_to_memory
		end

	EL_MODULE_CONVERT_STRING

	EL_MODULE_TUPLE
		rename
			Tuple as Tuple_
		end

	EL_STRING_8_CONSTANTS

	EL_SHARED_NEW_INSTANCE_TABLE; EL_SHARED_ZSTRING_BUFFER_POOL

create
	make

feature {EL_CLASS_META_DATA} -- Initialization

	post_make
		-- initialization after types have been set
		do
			create member_types.make_from_static (type_id)
			factory_array := new_factory_array
			Precursor
		end

feature -- Access

	field_name_list: detachable EL_STRING_8_LIST
		-- names assigned to tuple members by redefining `{EL_REFLECTIVE}.new_tuple_field_names'

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

	default_string_separator: BOOLEAN
		do
			Result := new_split_list = Void
		end

feature -- Basic operations

	reset (object: ANY)
		do
			if attached value (object) as tuple then
				Tuple_.reset (tuple)
				if tuple.count /= Tuple_.last_reset_count then
					initialize (object)
				end
			else
				initialize (object)
			end
		end

	set_field_name_list (name_list: EL_STRING_8_LIST)
		require
			valid_count: name_list.count = member_types.count
		do
			field_name_list := name_list
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			Tuple_.read (value (object), memory)
		end

	set_from_readable (object: ANY; reader: EL_READABLE)
		do
			if member_types.is_latin_1_representable then
				set_from_string (object, reader.read_string_8)
			else
				set_from_string (object, reader.read_string)
			end
		end

	set_from_string (object: ANY; value_list: READABLE_STRING_GENERAL)
		require else
			valid_comma_count: default_string_separator implies (value_list.occurrences (',') + 1) = member_types.count
		do
			if attached value (object) as tuple then
				if attached new_split_list as new_list and then attached new_list (value_list) as list then
					Tuple_.fill_from_list (tuple, list)

				elseif attached Convert_string.split_list (value_list, ',', {EL_SIDE}.Left) as list then
					list.prune_enclosing ('[', ']')
					Tuple_.fill_from_list (tuple, list)
				end
			end
		ensure then
			set: default_string_separator implies lists_match (value_list, to_string (object))
		end

	set_split_list_function (function: like new_split_list)
		-- set optional function for splitting string in `set_from_string'
		do
			new_split_list := function
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			if attached value (object) as tuple then
				writeable.write_character_8 ('[')
				Tuple_.write_with_comma (tuple, writeable, True)
				writeable.write_character_8 (']')
			end
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			Precursor (crc)
			if attached field_name_list as name_list then
				across name_list as list loop
					crc.add_string_8 (list.item)
				end
			end
		end

	write_to_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as tuple then
				Tuple_.write (tuple, memory, Void)
			end
		end

feature -- Conversion

	to_string (object: ANY): READABLE_STRING_GENERAL
		do
			if attached value (object) as tuple and then attached String_pool.borrowed_item as borrowed then
				if attached borrowed.empty as str then
					str.append_character_8 ('[')
					Tuple_.write_with_comma (tuple, str, True)
					str.append_character_8 (']')
					if member_types.is_latin_1_representable then
						Result := str.to_latin_1
					else
						Result := str.twin
					end
				end
				borrowed.return
			end
		end

feature {NONE} -- Implementation

	lists_match (csv_list_1, csv_list_2: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if lists match and taking account of DOUBLE approximations
		-- Example: 1.3 same as 1.3000000000002
		local
			list_1, list_2: EL_ZSTRING_LIST
			item_1, item_2: ZSTRING; double: EL_DOUBLE_MATH
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
						Result := double.approximately_equal (item_1.to_double, item_2.to_double, 0.00000000001)
					else
						Result := False
					end
				end
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

feature {NONE} -- Internal attributes

	factory_array: like new_factory_array

	new_split_list: detachable FUNCTION [READABLE_STRING_GENERAL, EL_SPLIT_READABLE_STRING_LIST [READABLE_STRING_GENERAL]]

feature {NONE} -- Constants

	Is_abstract: BOOLEAN = True
		-- `True' if field type is deferred

	Is_storable_type: BOOLEAN = False
		-- is type storable using `EL_STORABLE' interface

end