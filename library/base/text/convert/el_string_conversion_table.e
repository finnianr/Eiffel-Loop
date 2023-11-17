note
	description: "[
		Table of converters conforming to [$source EL_READABLE_STRING_GENERAL_TO_TYPE [ANY]]
		for converting strings conforming to [$source READABLE_STRING_GENERAL] to common data types
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-17 16:21:00 GMT (Friday 17th November 2023)"
	revision: "30"

class
	EL_STRING_CONVERSION_TABLE

inherit
	EL_HASH_TABLE [EL_READABLE_STRING_GENERAL_TO_TYPE [ANY], INTEGER]
		rename
			make as make_table,
			has_key as has_type
		export
			{NONE} all
			{ANY} has, has_type, found_item
		end

	EL_STRING_CONVERSION_TABLE_IMPLEMENTATION
		undefine
			copy, default_create, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
		local
			type_array: EL_TUPLE_TYPE_ARRAY
		do
			make_implementation

			create type_array.make_from_tuple (converter_types)
			make_size (type_array.count)

			across type_array as type loop
				if attached {like item} Eiffel.new_object (type.item) as converter then
					converter.make
					extend (converter, converter.type_id)
					if converter.abstract_type /= Reference_type then
						basic_type_converter [converter.abstract_type] := converter
					end
				end
			end
		end

feature -- Access

	split_list (value_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; adjustments: INTEGER): like filled_split_list
		do
			Result := filled_split_list (value_list, separator, adjustments).twin
		end

	type_descripton (type: TYPE [ANY]): STRING
		do
			if has_type (type.type_id) then
				Result := found_item.type_description
			else
				Result := Naming.class_description_from (type, Naming.No_words)
			end
		end

	type_list: EL_ARRAYED_LIST [TYPE [ANY]]
		do
			create Result.make (count)
			across current_keys as key loop
				if has_type (key.item) then
					Result.extend (found_item.type)
				end
			end
		end

feature -- Integer substrings

	substring_to_integer_8 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_8
		do
			if attached {EL_STRING_TO_INTEGER_8} basic_type_converter [Integer_8_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

	substring_to_integer_16 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_16
		do
			if attached {EL_STRING_TO_INTEGER_16} basic_type_converter [Integer_16_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

	substring_to_integer_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_32
		do
			if attached {EL_STRING_TO_INTEGER_32} basic_type_converter [Integer_32_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

	substring_to_integer_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_64
		do
			if attached {EL_STRING_TO_INTEGER_64} basic_type_converter [Integer_64_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

feature -- Natural substrings

	substring_to_natural_8 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_8
		do
			if attached {EL_STRING_TO_NATURAL_8} basic_type_converter [Natural_8_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

	substring_to_natural_16 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_16
		do
			if attached {EL_STRING_TO_NATURAL_16} basic_type_converter [Natural_16_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

	substring_to_natural_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_32
		do
			if attached {EL_STRING_TO_NATURAL_32} basic_type_converter [Natural_32_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

	substring_to_natural_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_64
		do
			if attached {EL_STRING_TO_NATURAL_64} basic_type_converter [Natural_64_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

feature -- Real substrings

	substring_to_real_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): REAL_32
		do
			if attached {EL_STRING_TO_REAL_32} basic_type_converter [Real_32_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

	substring_to_real_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): REAL_64
		do
			if attached {EL_STRING_TO_REAL_64} basic_type_converter [Real_64_type] as converter then
				Result := converter.substring_as_type (str, start_index, end_index)
			end
		end

feature -- Numeric conversion

	to_integer (str: READABLE_STRING_GENERAL): INTEGER
		require
			integer_string: is_integer (str)
		do
			if attached {EL_STRING_TO_INTEGER_32} basic_type_converter [Integer_32_type] as converter then
				Result := converter.as_type (str)
			end
		end

	to_natural (str: READABLE_STRING_GENERAL): NATURAL_32
		require
			natural_string: is_natural (str)
		do
			if attached {EL_STRING_TO_NATURAL_32} basic_type_converter [Natural_32_type] as converter then
				Result := converter.as_type (str)
			end
		end

	to_natural_64 (str: READABLE_STRING_GENERAL): NATURAL_64
		require
			natural_string: is_natural (str)
		do
			if attached {EL_STRING_TO_NATURAL_64} basic_type_converter [Natural_64_type] as converter then
				Result := converter.as_type (str)
			end
		end

feature -- Numeric tests

	is_integer (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := basic_type_converter [Integer_32_type].is_convertible (str)
		end

	is_natural (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := basic_type_converter [Natural_32_type].is_convertible (str)
		end

	is_natural_64 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := basic_type_converter [Natural_64_type].is_convertible (str)
		end

feature -- Status query

	has_converter (type: TYPE [ANY]): BOOLEAN
		-- `True' if table has converter for `type'
		-- set `found_item' as converter if found
		do
			Result := has_type (type.type_id)
		end

	is_convertible (str: READABLE_STRING_GENERAL; type: TYPE [ANY]): BOOLEAN
		do
			Result := is_convertible_to_type (str, type.type_id)
		end

	is_convertible_list (
		item_type_id: INTEGER; value_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; adjustments: INTEGER
	): BOOLEAN
		do
			Result := True
			if attached filled_split_list (value_list, separator, adjustments) as list then
				from list.start until not Result or else list.after loop
					Result := is_convertible_to_type (list.item, item_type_id)
					list.forth
				end
			end
		end

	is_convertible_to_type (str: READABLE_STRING_GENERAL; type_id: INTEGER): BOOLEAN
		-- `True' if `str' is convertible to type with `type_id'
		do
			if {ISE_RUNTIME}.dynamic_type (str) = type_id then
				Result := True

			elseif has_type (type_id) then
				Result := found_item.is_convertible (str)
			else
				Result := {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.EL_MAKEABLE_FROM_STRING)
			end
		end

	is_convertible_tuple (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN): BOOLEAN
		local
			type_array: EL_TUPLE_TYPE_ARRAY; type_id: INTEGER
		do
			if csv_list.occurrences (',') + 1 >= tuple.count then
				type_array := Mod_tuple.type_array (tuple)
				Result := True
				if attached filled_split_list (csv_list, ',', left_adjusted.to_integer) as list then
					from list.start until list.after or else not Result or else list.index > tuple.count loop
						type_id := type_array [list.index].type_id
						Result := is_substring_convertible_to_type (csv_list, list.item_lower, list.item_upper, type_id)
						list.forth
					end
				end
			end
		end

	is_substring_convertible_to_type (str: READABLE_STRING_GENERAL; start_index, end_index, type_id: INTEGER): BOOLEAN
		-- `True' if `str' is convertible to type with `type_id'
		do
			if {ISE_RUNTIME}.dynamic_type (str) = type_id then
				Result := True

			elseif has_type (type_id) then
				Result := found_item.is_substring_convertible (str, start_index, end_index)
			else
				Result := {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.EL_MAKEABLE_FROM_STRING)
			end
		end

	is_latin_1 (type: TYPE [ANY]): BOOLEAN
		-- `True' if type can be always be represented by Latin-1 encoded string
		do
			if has_type (type.type_id) then
				Result := found_item.is_latin_1
			end
		end

feature -- Basic operations

	append_to_chain (
		item_type_id: INTEGER; chain: CHAIN [ANY]; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN
	)
		require
			convertable: is_convertible_list (item_type_id, csv_list, ',', left_adjusted.to_integer)
		local
			lower, upper: INTEGER
		do
			if attached filled_split_list (csv_list, ',', left_adjusted.to_integer) as list then
				from list.start until list.after loop
					lower := list.item_lower; upper := list.item_upper
					if is_substring_convertible_to_type (csv_list, lower, upper, item_type_id) then
						chain.extend (substring_to_type_of_type (csv_list, lower, upper, item_type_id))
					else
						check i_th_type_convertible: True end
					end
					list.forth
				end
			end
		ensure
			filled: csv_list.count > 0 implies chain.count - old chain.count = csv_list.occurrences (',') + 1
		end

	fill_tuple (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN)
		-- fill tuple with STRING items from comma-separated list `csv_list' of strings
		-- TUPLE may contain any of types in `current_keys'
		-- items are left adjusted if `left_adjusted' is True
		require
			tuple_convertible: is_convertible_tuple (tuple, csv_list, left_adjusted)
		do
			fill_tuple_from_list (tuple, split_list (csv_list, ',', left_adjusted.to_integer))
		end

	fill_tuple_from_list (tuple: TUPLE; list: like split_list)
		require
			same_count: list.count = tuple.count
		local
			type_array: EL_TUPLE_TYPE_ARRAY; item_type: TYPE [ANY]
			type_id, lower, upper, index: INTEGER
		do
			type_array := Mod_tuple.type_array (tuple)
			if attached list.target_string as list_string then
				from list.start until list.after or else list.index > tuple.count loop
					index := list.index
					item_type := type_array [index]
					lower := list.item_lower; upper := list.item_upper
					type_id := item_type.type_id
					if is_substring_convertible_to_type (list_string, lower, upper, type_id) then
						if tuple.is_reference_item (index) then
							tuple.put_reference (substring_to_type_of_type (list_string, lower, upper, type_id), index)
						else
							tuple.put (substring_to_type_of_type (list_string, lower, upper, type_id), index)
						end
					else
						check i_th_type_convertible: True end
					end
					list.forth
				end
			end
		ensure
			filled: Mod_tuple.is_filled (tuple, 1, tuple.count)
		end

	substring_to_type (
		str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER; type: TYPE [ANY]
	): detachable ANY
		do
			Result := substring_to_type_of_type (str, start_index, end_index, type.type_id)
		end

	substring_to_type_of_type (
		str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER; type_id: INTEGER
	): detachable ANY
		-- `str.substring (start_index, end_index)' converted to type with `type_id'
		require
			convertible: is_convertible_to_type (str.substring (start_index, end_index), type_id)
		do
			if {ISE_RUNTIME}.dynamic_type (str) = type_id then
				Result := str.substring (start_index, end_index)

			elseif has_type (type_id) then
				Result := found_item.substring_as_type (str, start_index, end_index)

			elseif {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.EL_MAKEABLE_FROM_STRING)
				and then attached Makeable_from_string_factory.new_item_factory (type_id) as factory
			then
				inspect Class_id.character_bytes (str)
					when '1' then
						if attached {READABLE_STRING_8} str as str_8 then
							across String_8_scope as scope loop
								Result := factory.new_item (scope.substring_item (str_8, start_index, end_index))
							end
						end
					when '4' then
						if attached {READABLE_STRING_32} str as str_32 then
							across String_32_scope as scope loop
								Result := factory.new_item (scope.substring_item (str_32, start_index, end_index))
							end
						end
					when 'X' then
						if attached {EL_READABLE_ZSTRING} str as zstr then
							across String_scope as scope loop
								Result := factory.new_item (scope.substring_item (zstr, start_index, end_index))
							end
						end
				end
			end
		end

	to_type (str: READABLE_STRING_GENERAL; type: TYPE [ANY]): detachable ANY
		-- `str' converted to type `type'
		do
			Result := to_type_of_type (str, type.type_id)
		end

	to_type_of_type (str: READABLE_STRING_GENERAL; type_id: INTEGER): detachable ANY
		-- `str' converted to type with `type_id'
		require
			convertible: is_convertible_to_type (str, type_id)
		do
			if {ISE_RUNTIME}.dynamic_type (str) = type_id then
				Result := str

			elseif has_type (type_id) then
				Result := found_item.as_type (str)

			elseif {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.EL_MAKEABLE_FROM_STRING)
				and then attached Makeable_from_string_factory.new_item_factory (type_id) as factory
			then
				inspect Class_id.character_bytes (str)
					when '1' then
						if attached {READABLE_STRING_8} str as str_8 then
							across String_8_scope as scope loop
								Result := factory.new_item (scope.copied_item (str_8))
							end
						end
					when '4' then
						if attached {READABLE_STRING_32} str as str_32 then
							across String_32_scope as scope loop
								Result := factory.new_item (scope.copied_item (str_32))
							end
						end
					when 'X' then
						if attached {EL_READABLE_ZSTRING} str as zstr then
							across String_scope as scope loop
								Result := factory.new_item (scope.copied_item (zstr))
							end
						end
				end
			end
		end

note
	notes: "[
		Conversion targets:

			[$source INTEGER_8], [$source INTEGER_16], [$source INTEGER_32], [$source INTEGER_64],

			[$source NATURAL_8], [$source NATURAL_16], [$source NATURAL_32, [$source NATURAL_64],

			[$source REAL_32], [$source REAL_64],

			[$source BOOLEAN], [$source CHARACTER_8], [$source CHARACTER_32],

			[$source STRING_8], [$source STRING_32],
			[$source IMMUTABLE_STRING_8], [$source IMMUTABLE_STRING_32],

			[$source ZSTRING],
			[$source DIR_PATH], [$source FILE_PATH],

			[$source EL_DIR_URI_PATH], [$source EL_FILE_URI_PATH]

	]"
end