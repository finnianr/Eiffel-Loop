note
	description: "[
		Routines for populating tuple fields and converting to and from string types.
		Accessible via shared instance ${EL_MODULE_TUPLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 15:24:50 GMT (Thursday 17th April 2025)"
	revision: "63"

class
	EL_TUPLE_ROUTINES

inherit
	EL_INTEGER_MATH_I

	EL_EXTENDED_REFLECTOR
		rename
			string_width as string_width_of
		export
			{NONE} all
		redefine
			make
		end

	EL_SIDE_ROUTINES
		export
			{ANY} valid_side
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_OBJECT_PROPERTY_I

	EL_MODULE_CONVERT_STRING

	EL_STRING_8_CONSTANTS; EL_CHARACTER_8_CONSTANTS; EL_TYPE_CATEGORY_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create types_table.make (17, agent new_type_array)
			create procedure
			create empty
			create counter
		end

feature -- Access

	all_readable_strings (tuple: TUPLE): BOOLEAN
		-- True if all `tuple' items conform to `READABLE_STRING_GENERAL'
		do
			Result := type_array (tuple).all_conform_to ({READABLE_STRING_GENERAL})
		end

	closed_operands (a_procedure: PROCEDURE): TUPLE
		do
			procedure.set_from_other (a_procedure)
			Result := procedure.closed_operands
		end

	empty: TUPLE

	last_reset_count: INTEGER
		do
			Result := counter.item.to_integer_32
		end

	special_type_array (tuple: TUPLE): SPECIAL [INTEGER]
		do
			if attached new_type_array ({ISE_RUNTIME}.dynamic_type (tuple)) as array then
				create Result.make_empty (array.count)
				across array as a loop
					Result.extend (a.item.type_id)
				end
			else
				create Result.make_empty (0)
			end
		ensure
			same_count: Result.count = tuple.count
		end

	type_array (tuple: TUPLE): EL_TUPLE_TYPE_ARRAY
		-- Caches results in `types_table'
		do
			Result := types_table.item ({ISE_RUNTIME}.dynamic_type (tuple))
		end

feature -- Measurement

	i_th_string_width (tuple: TUPLE; i: INTEGER): INTEGER
		require
			valid_index: tuple.valid_index (i)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Boolean_code then
					if tuple.boolean_item (i) then
						Result := 4
					else
						Result := 5
					end
				when {TUPLE}.Character_8_code, {TUPLE}.Character_32_code then
					Result := 1

				when {TUPLE}.Pointer_code then
				--	Hexadecimal number
					Result := {PLATFORM}.pointer_bytes * 2 + 2

			--	Integers
				when {TUPLE}.Integer_8_code then
					Result := string_size (tuple.integer_8_item (i))

				when {TUPLE}.Integer_16_code then
					Result := string_size (tuple.integer_16_item (i))

				when {TUPLE}.Integer_32_code then
					Result := string_size (tuple.integer_32_item (i))

				when {TUPLE}.Integer_64_code then
					Result := string_size (tuple.integer_64_item (i))

			--	Naturals
				when {TUPLE}.Natural_8_code then
					Result := natural_digit_count (tuple.natural_8_item (i))

				when {TUPLE}.Natural_16_code then
					Result := natural_digit_count (tuple.natural_16_item (i))

				when {TUPLE}.Natural_32_code then
					Result := natural_digit_count (tuple.natural_32_item (i))

				when {TUPLE}.Natural_64_code then
					Result := natural_digit_count (tuple.natural_64_item (i))

			-- Reals
				when {TUPLE}.Real_32_code then
					Result := tuple.real_32_item (i).out.count

				when {TUPLE}.Real_64_code then
					Result := tuple.real_64_item (i).out.count

			-- Reference
				when {TUPLE}.Reference_code then
					if attached tuple.reference_item (i) as ref_item then
						Result := string_width_of (ref_item)
					end
			else
			end
		end

	string_width (tuple: TUPLE): INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				Result := Result + i_th_string_width (tuple, i)
				i := i + 1
			end
		end

feature -- Conversion

	to_string_32_list (tuple: TUPLE): EL_STRING_32_LIST
		do
			Result := tuple
		end

	to_string_8_list (tuple: TUPLE): EL_STRING_8_LIST
		do
			Result := tuple
		end

	to_zstring_list (tuple: TUPLE): EL_ZSTRING_LIST
		do
			Result := tuple
		end

feature -- Basic operations

	append_i_th (tuple: TUPLE; i: INTEGER; string: STRING_32)
		-- append i'th item of `tuple' to `string'
		require
			valid_index: tuple.valid_index (i)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Integer_8_code then
					string.append_integer_8 (tuple.integer_8_item (i))

				when {TUPLE}.Integer_16_code then
					string.append_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Integer_32_code then
					string.append_integer (tuple.integer_32_item (i))

				when {TUPLE}.Integer_64_code then
					string.append_integer_64 (tuple.integer_64_item (i))

				when {TUPLE}.Natural_8_code then
					string.append_natural_8 (tuple.natural_8_item (i))

				when {TUPLE}.Natural_16_code then
					string.append_natural_16 (tuple.natural_16_item (i))

				when {TUPLE}.Natural_32_code then
					string.append_natural_32 (tuple.natural_32_item (i))

				when {TUPLE}.Natural_64_code then
					string.append_natural_64 (tuple.natural_64_item (i))

				when {TUPLE}.Real_32_code then
					string.append_real (tuple.real_32_item (i))

				when {TUPLE}.Real_64_code then
					string.append_double (tuple.real_64_item (i))

				when {TUPLE}.Reference_code then
					if attached tuple.reference_item (i) as ref_item then
						if attached {READABLE_STRING_GENERAL} ref_item as general then
							if attached {ZSTRING} general as zstr then
								zstr.append_to_string_32 (string)
							else
								string.append_string_general (general)
							end
						elseif attached {EL_PATH} ref_item as path then
							path.append_to_32 (string)
						end
					end
				end
		end

	fill (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL)
		do
			fill_adjusted (tuple, csv_list, True)
		end

	fill_adjusted (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN)
		-- fill tuple with STRING items from comma-separated list `csv_list' of strings
		-- TUPLE may contain any of types STRING_8, STRING_32, ZSTRING
		-- items are left adjusted if `left_adjusted' is True
		do
			fill_for_separator (tuple, csv_list, ',', left_adjusted.to_integer)
		end

	fill_default (tuple: TUPLE; default_value: ANY)
		local
			i: INTEGER; type_id: INTEGER
		do
			type_id := {ISE_RUNTIME}.dynamic_type (default_value)
			if attached type_array (tuple) as tuple_types then
				from i := 1 until i > tuple.count loop
					inspect tuple.item_code (i)
						when {TUPLE}.Reference_code then
							if field_conforms_to (type_id, tuple_types [i].type_id) then
								tuple.put_reference (default_value, i)
							end
					else
					end
					i := i + 1
				end
			end
		ensure
			filled: is_filled (tuple, 1, tuple.count)
		end

	fill_for_separator (tuple: TUPLE; value_list: READABLE_STRING_GENERAL; separator: CHARACTER; adjustments: INTEGER)
		require
			valid_adjustments: valid_side (adjustments)
			enough_list_items: tuple.count <= value_list.occurrences (separator) + 1
		local
			i: INTEGER
		do
			if attached Convert_string as cs and then attached type_array (tuple) as type then
				across split_adjusted (value_list, separator, adjustments) as list loop
					i := list.cursor_index
					put_i_th (tuple, i, value_list, list.item_lower, list.item_upper, type [i].type_id, cs)
				end
			end
		ensure
			filled: is_filled (tuple, 1, tuple.count)
		end

	fill_from_list (tuple: TUPLE; list: EL_SPLIT_READABLE_STRING_LIST [READABLE_STRING_GENERAL])
		require
			enough_list_items: tuple.count <= list.count
		local
			i: INTEGER
		do
			if attached list.target_string as string and then attached Convert_string as cs
				and then attached type_array (tuple) as type
			then
				from list.start until list.after or else list.index > tuple.count loop
					i := list.index
					put_i_th (tuple, i, string, list.item_lower, list.item_upper, type [i].type_id, cs)
					list.forth
				end
			end
		ensure
			filled: is_filled (tuple, 1, tuple.count)
		end

	fill_immutable (tuple: TUPLE; csv_list: STRING)
		-- fill tuple with `IMMUTABLE_STRING_8' items from comma-separated list `csv_list' of strings
		-- created items are left adjusted and share the same `SPECIAL [CHARACTER]' area
		require
			all_immutable_string_8: type_array (tuple).is_uniformly ({IMMUTABLE_STRING_8})
		local
			comma_splitter: EL_SPLIT_IMMUTABLE_STRING_8_LIST; tuple_types: EL_TUPLE_TYPE_ARRAY
		do
			tuple_types := type_array (tuple)
			create comma_splitter.make_shared_adjusted (csv_list, ',', {EL_SIDE}.Left)
			across comma_splitter as list until list.cursor_index > tuple.count loop
				if tuple_types [list.cursor_index].type_id = class_id.IMMUTABLE_STRING_8 then
					tuple.put_reference (list.item, list.cursor_index)
				end
			end
		ensure
			filled: is_filled (tuple, 1, tuple.count)
		end

	fill_with_new (tuple: TUPLE; csv_field_list: STRING; a_new_item: FUNCTION [STRING, ANY]; start_index: INTEGER)
		-- fill tuple from `start_index' with factory function call `a_new_item (x)' where `x' is a field name
		-- in the comma separated field list `csv_field_list'
		require
			valid_start_index: start_index >= 1
			valid_list: csv_field_list.count > 0 and then start_index + csv_field_list.occurrences (',') <= tuple.count
			not_filled:	not is_filled (tuple, start_index, start_index + csv_field_list.occurrences (','))
		local
			result_type_id: INTEGER; comma_splitter: EL_SPLIT_ON_CHARACTER_8 [STRING_8]
			tuple_types: EL_TUPLE_TYPE_ARRAY; index: INTEGER
		do
			result_type_id := a_new_item.generating_type.generic_parameter_type (2).type_id
			tuple_types := type_array (tuple)
			create comma_splitter.make_adjusted (csv_field_list, ',', {EL_SIDE}.Left)

			across comma_splitter as list until (start_index + list.cursor_index - 1) > tuple.count loop
				index := start_index + list.cursor_index - 1
				if tuple.item_code (index) = {TUPLE}.Reference_code and then
					field_conforms_to (result_type_id, tuple_types [index].type_id)
					and then attached a_new_item (list.item_copy) as new
				then
					tuple.put_reference (new, index)
				end
			end
		ensure
			filled: is_filled (tuple, start_index, start_index + csv_field_list.occurrences (','))
		end

	line_fill (tuple: TUPLE; line_list: READABLE_STRING_GENERAL)
		do
			fill_for_separator (tuple, line_list, '%N', 0)
		end

	read (tuple: TUPLE; readable: EL_READABLE)
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				set_i_th (tuple, i, readable, 0)
				i := i + 1
			end
		end

	reset (tuple: TUPLE)
		-- reset all tuple items to default values, wiping out any strings
		-- `last_reset_count' returns the number of items reset
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				reset_i_th (tuple, i, tuple.item_code (i))
				i := i + 1
			end
		end

	reset_i_th (tuple: TUPLE; i, type_id: INTEGER)
		require
			valid_index: tuple.valid_index (i)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Character_8_code then
					tuple.put_character ('%U', i); counter.bump

				when {TUPLE}.Character_32_code then
					tuple.put_character_32 ('%U', i); counter.bump

				when {TUPLE}.Boolean_code then
					tuple.put_boolean (False, i); counter.bump

				when {TUPLE}.Pointer_code then
					tuple.put_pointer (default_pointer, i)

				when {TUPLE}.Integer_8_code then
					tuple.put_integer_8 (0, i); counter.bump

				when {TUPLE}.Integer_16_code then
					tuple.put_integer_16 (0, i); counter.bump

				when {TUPLE}.Integer_32_code then
					tuple.put_integer (0, i); counter.bump

				when {TUPLE}.Integer_64_code then
					tuple.put_integer_64 (0, i); counter.bump

				when {TUPLE}.Natural_8_code then
					tuple.put_natural_8 (0, i); counter.bump

				when {TUPLE}.Natural_16_code then
					tuple.put_natural_16 (0, i); counter.bump

				when {TUPLE}.Natural_32_code then
					tuple.put_natural_32 (0, i); counter.bump

				when {TUPLE}.Natural_64_code then
					tuple.put_natural_64 (0, i); counter.bump

				when {TUPLE}.Real_32_code then
					tuple.put_real_32 (0, i); counter.bump

				when {TUPLE}.Real_64_code then
					tuple.put_real_64 (0, i); counter.bump

				when {TUPLE}.Reference_code then
					reset_i_th_reference (
						tuple, tuple.reference_item (i), i, property (tuple).generic_dynamic_type (i)
					)
			else
			end
		end

	set_i_th (tuple: TUPLE; i: INTEGER; readable: EL_READABLE; type_id: INTEGER)
		require
			valid_index: tuple.valid_index (i)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Character_8_code then
					tuple.put_character (readable.read_character_8, i)

				when {TUPLE}.Character_32_code then
					tuple.put_character_32 (readable.read_character_32, i)

				when {TUPLE}.Boolean_code then
					tuple.put_boolean (readable.read_boolean, i)

				when {TUPLE}.Pointer_code then
					tuple.put_pointer (readable.read_pointer, i)

				when {TUPLE}.Integer_8_code then
					tuple.put_integer_8 (readable.read_integer_8, i)

				when {TUPLE}.Integer_16_code then
					tuple.put_integer_16 (readable.read_integer_16, i)

				when {TUPLE}.Integer_32_code then
					tuple.put_integer (readable.read_integer_32, i)

				when {TUPLE}.Integer_64_code then
					tuple.put_integer_64 (readable.read_integer_64, i)

				when {TUPLE}.Natural_8_code then
					tuple.put_natural_8 (readable.read_natural_8, i)

				when {TUPLE}.Natural_16_code then
					tuple.put_natural_16 (readable.read_natural_16, i)

				when {TUPLE}.Natural_32_code then
					tuple.put_natural_32 (readable.read_natural_32, i)

				when {TUPLE}.Natural_64_code then
					tuple.put_natural_64 (readable.read_natural_64, i)

				when {TUPLE}.Real_32_code then
					tuple.put_real_32 (readable.read_real_32, i)

				when {TUPLE}.Real_64_code then
					tuple.put_real_64 (readable.read_real_64, i)

				when {TUPLE}.Reference_code then
					set_i_th_reference (tuple, i, readable, property (tuple).generic_dynamic_type (i))
			else
			end
		end

	set_i_th_as_expanded (tuple: TUPLE; i: INTEGER; object: ANY)
		require
			valid_index: tuple.valid_index (i)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Character_8_code then
					if attached {CHARACTER_8_REF} object as ref then
						tuple.put_character (ref.item, i)
					end

				when {TUPLE}.Character_32_code then
					if attached {CHARACTER_32_REF} object as ref then
						tuple.put_character_32 (ref.item, i)
					end

				when {TUPLE}.Boolean_code then
					if attached {BOOLEAN_REF} object as ref then
						tuple.put_boolean (ref.item, i)
					end

				when {TUPLE}.Pointer_code then
					if attached {POINTER_REF} object as ref then
						tuple.put_pointer (ref.item, i)
					end

				when {TUPLE}.Integer_8_code then
					if attached {INTEGER_8_REF} object as ref then
						tuple.put_integer_8 (ref.item, i)
					end

				when {TUPLE}.Integer_16_code then
					if attached {INTEGER_16_REF} object as ref then
						tuple.put_integer_16 (ref.item, i)
					end

				when {TUPLE}.Integer_32_code then
					if attached {INTEGER_32_REF} object as ref then
						tuple.put_integer (ref.item, i)
					end

				when {TUPLE}.Integer_64_code then
					if attached {INTEGER_64_REF} object as ref then
						tuple.put_integer_64 (ref.item, i)
					end

				when {TUPLE}.Natural_8_code then
					if attached {NATURAL_8_REF} object as ref then
						tuple.put_natural_8 (ref.item, i)
					end

				when {TUPLE}.Natural_16_code then
					if attached {NATURAL_16_REF} object as ref then
						tuple.put_natural_16 (ref.item, i)
					end

				when {TUPLE}.Natural_32_code then
					if attached {NATURAL_32_REF} object as ref then
						tuple.put_natural_32 (ref.item, i)
					end

				when {TUPLE}.Natural_64_code then
					if attached {NATURAL_64_REF} object as ref then
						tuple.put_natural_64 (ref.item, i)
					end

				when {TUPLE}.Real_32_code then
					if attached {REAL_32_REF} object as ref then
						tuple.put_real_32 (ref.item, i)
					end

				when {TUPLE}.Real_64_code then
					if attached {REAL_64_REF} object as ref then
						tuple.put_real_64 (ref.item, i)
					end

				when {TUPLE}.Reference_code then
					tuple.put_reference (object, i)
			else
			end
		end

	write (tuple: TUPLE; writable: EL_WRITABLE; a_delimiter: detachable READABLE_STRING_8)
		local
			i: INTEGER; separator: CHARACTER; delimiter: READABLE_STRING_8
			has_delimiter: BOOLEAN
		do
			if attached a_delimiter as str then
				if str.count = 1 then
					separator := str [1]
				else
					delimiter := str
				end
				has_delimiter := True
			else
				delimiter := Empty_string_8
			end
			from i := 1 until i > tuple.count loop
				if i > 1 and has_delimiter then
					if separator = '%U' then
						writable.write_string_8 (delimiter)
					else
						writable.write_character_8 (separator)
					end
				end
				write_i_th (tuple, i, writable)
				i := i + 1
			end
		end

	write_i_th (tuple: TUPLE; i: INTEGER; writable: EL_WRITABLE)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Character_8_code then
					writable.write_character_8 (tuple.character_8_item (i))

				when {TUPLE}.Character_32_code then
					writable.write_character_32 (tuple.character_32_item (i))

				when {TUPLE}.Boolean_code then
					writable.write_boolean (tuple.boolean_item (i))

				when {TUPLE}.Integer_8_code then
					writable.write_integer_8 (tuple.integer_8_item (i))

				when {TUPLE}.Integer_16_code then
					writable.write_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Integer_32_code then
					writable.write_integer_32 (tuple.integer_32_item (i))

				when {TUPLE}.Integer_64_code then
					writable.write_integer_64 (tuple.integer_64_item (i))

				when {TUPLE}.Natural_8_code then
					writable.write_natural_8 (tuple.natural_8_item (i))

				when {TUPLE}.Natural_16_code then
					writable.write_natural_16 (tuple.natural_16_item (i))

				when {TUPLE}.Natural_32_code then
					writable.write_natural_32 (tuple.natural_32_item (i))

				when {TUPLE}.Natural_64_code then
					writable.write_natural_64 (tuple.natural_64_item (i))

				when {TUPLE}.Pointer_code then
					writable.write_pointer (tuple.pointer_item (i))

				when {TUPLE}.Real_32_code then
					writable.write_real_32 (tuple.real_32_item (i))

				when {TUPLE}.Real_64_code then
					writable.write_real_64 (tuple.real_64_item (i))

				when {TUPLE}.Reference_code then
					if attached tuple.reference_item (i) as object then
						writable.write_any (object)
					end
			else
			end
		end

	write_with_comma (tuple: TUPLE; writable: EL_WRITABLE; extra_space: BOOLEAN)
		do
			if extra_space then
				write (tuple, writable, Comma_space)
			else
				write (tuple, writable, comma)
			end
		end

feature -- Contract Support

	is_convertible (
		tuple: TUPLE; part_list: READABLE_STRING_GENERAL; separator: CHARACTER; left_adjusted: BOOLEAN
	): BOOLEAN
		do
			if part_list.occurrences (separator) + 1 >= tuple.count and then attached type_array (tuple) as type
				and then attached Convert_string as cs
			then
				Result := True
				if attached cs.filled_split_list (part_list, separator, left_adjusted.to_integer) as list then
					from list.start until list.after or else not Result or else list.index > tuple.count loop
						Result := cs.is_substring_convertible_to_type (
							part_list, list.item_lower, list.item_upper, type [list.index].type_id
						)
						list.forth
					end
				end
			end
		end

feature {NONE} -- Factory

	new_read_path (readable: EL_READABLE; type_id: INTEGER): EL_PATH
		do
			if type_id = class_id.DIR_PATH then
				create {DIR_PATH} Result.make (readable.read_string)

			elseif type_id = class_id.FILE_PATH then
				create {FILE_PATH} Result.make (readable.read_string)

			elseif type_id = class_id.EL_DIR_URI_PATH then
				create {EL_DIR_URI_PATH} Result.make (readable.read_string)

			elseif type_id = class_id.EL_FILE_URI_PATH then
				create {EL_FILE_URI_PATH} Result.make (readable.read_string)
			end
		end

	new_read_string_32 (readable: EL_READABLE; type_id: INTEGER): READABLE_STRING_32
		do
			if type_id = class_id.ZSTRING then
				Result := readable.read_string

			elseif type_id = class_id.STRING_32 then
				Result := readable.read_string_32

			elseif type_id = class_id.IMMUTABLE_STRING_32 then
				create {IMMUTABLE_STRING_32} Result.make_from_string_32 (readable.read_string_32)
			end
		end

	new_read_string_8 (readable: EL_READABLE; type_id: INTEGER): READABLE_STRING_8
		do
			if type_id = class_id.STRING_8 then
				Result := readable.read_string_8

			elseif type_id = class_id.IMMUTABLE_STRING_8 then
				create {IMMUTABLE_STRING_8} Result.make_from_string (readable.read_string_8)
			end
		end

	new_type_array (static_type: INTEGER): EL_TUPLE_TYPE_ARRAY
		do
			create Result.make_from_static (static_type)
		end

feature {NONE} -- Implementation

	put_i_th (
		tuple: TUPLE; i: INTEGER; string: READABLE_STRING_GENERAL; lower, upper, type_id: INTEGER
		cs: like Convert_string
	)
		require
			valid_index: tuple.valid_index (i)
			i_th_convertible_to_type: cs.is_substring_convertible_to_type (string, lower, upper, type_id)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Character_8_code then
					tuple.put_character (string [lower].to_character_8, i)

				when {TUPLE}.Character_32_code then
					tuple.put_character_32 (string [lower], i)

				when {TUPLE}.Boolean_code then
					tuple.put_boolean (cs.boolean.substring_as_type (string, lower, upper), i)

				when {TUPLE}.Pointer_code then
					do_nothing

				when {TUPLE}.Integer_8_code then
					tuple.put_integer_8 (cs.substring_to_integer_8 (string, lower, upper), i)

				when {TUPLE}.Integer_16_code then
					tuple.put_integer_16 (cs.substring_to_integer_16 (string, lower, upper), i)

				when {TUPLE}.Integer_32_code then
					tuple.put_integer (cs.substring_to_integer_32 (string, lower, upper), i)

				when {TUPLE}.Integer_64_code then
					tuple.put_integer_64 (cs.substring_to_integer_64 (string, lower, upper), i)

				when {TUPLE}.Natural_8_code then
					tuple.put_natural_8 (cs.substring_to_natural_8 (string, lower, upper), i)

				when {TUPLE}.Natural_16_code then
					tuple.put_natural_16 (cs.substring_to_natural_16 (string, lower, upper), i)

				when {TUPLE}.Natural_32_code then
					tuple.put_natural_32 (cs.substring_to_natural_32 (string, lower, upper), i)

				when {TUPLE}.Natural_64_code then
					tuple.put_natural_64 (cs.substring_to_natural_64 (string, lower, upper), i)

				when {TUPLE}.Real_32_code then
					tuple.put_real_32 (cs.substring_to_real_32 (string, lower, upper), i)

				when {TUPLE}.Real_64_code then
					tuple.put_real_64 (cs.substring_to_real_64 (string, lower, upper), i)

				when {TUPLE}.Reference_code then
					tuple.put_reference (cs.substring_to_type_of_type (string, lower, upper, type_id), i)
			else
			end
		end

	reset_i_th_reference (tuple: TUPLE; ref_item: ANY; i, type_id: INTEGER)
		do
			if is_bag_type (type_id) and then attached {BAG [ANY]} ref_item as bag then
			-- includes `STRING_GENERAL'
				bag.wipe_out; counter.bump

			elseif is_type_in_set (type_id, class_id.el_path_types)
				and then attached {EL_PATH} ref_item as path
			then
				path.wipe_out; counter.bump

			elseif type_id = class_id.PATH and then attached {PATH} ref_item as path then
				tuple.put_reference (create {PATH}.make_empty, i); counter.bump

			elseif is_type_in_set (type_id, class_id.immutable_string_types) and then
				attached {IMMUTABLE_STRING_GENERAL} ref_item as immutable
			then
				if immutable.is_string_8 then
					tuple.put_reference (create {IMMUTABLE_STRING_8}.make_empty, i)
					counter.bump
				else
					tuple.put_reference (create {IMMUTABLE_STRING_32}.make_empty, i)
					counter.bump
				end
			end
		end

	set_i_th_reference (tuple: TUPLE; i: INTEGER; readable: EL_READABLE; type_id: INTEGER)
		do
			inspect class_id.type_category (type_id)
				when C_readable_string_8 then
					tuple.put_reference (new_read_string_8 (readable, type_id), i)

				when C_readable_string_32 then
					tuple.put_reference (new_read_string_32 (readable, type_id), i)

				when C_el_path then
					tuple.put_reference (new_read_path (readable, type_id), i)
			else
			end
		end

feature {NONE} -- Internal attributes

	counter: EL_NATURAL_32_COUNTER

	procedure: EL_PROCEDURE

	types_table: EL_AGENT_CACHE_TABLE [EL_TUPLE_TYPE_ARRAY, INTEGER]

feature -- Contract Support

	is_filled (tuple: TUPLE; start_index, end_index: INTEGER): BOOLEAN
		do
			Result := across start_index |..| end_index as i_th all
				tuple.is_reference_item (i_th.item) implies attached tuple.reference_item (i_th.item)
			end
		end

end