note
	description: "[
		Table of converters conforming to ${EL_READABLE_STRING_GENERAL_TO_TYPE [ANY]}
		for converting strings conforming to ${READABLE_STRING_GENERAL} to common data types
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 7:54:03 GMT (Sunday 25th August 2024)"
	revision: "36"

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

	EL_SHARED_FACTORIES; EL_SHARED_CLASS_ID

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

			if attached new_expanded_table as expanded_table then
				across type_array as type loop
					if expanded_table.has_key (type.item) and then attached expanded_table.found_item as converter then
						extend (converter, converter.type_id)

					elseif attached Makeable_factory.new_item_factory (type.item.type_id) as factory
						and then attached {like item} factory.new_item as converter
					then
						extend (converter, converter.type_id)
					end
				end
			end
		ensure
			table_complete: count = converter_types.count
		end

feature -- Access

	split_list (value_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; adjustments: INTEGER): like filled_split_list
		-- split `value_list' with white space adjustments: `Both', `Left', `None', `Right'. (See class `EL_SIDE')
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
			Result := integer_8_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_integer_16 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_16
		do
			Result := integer_16_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_integer_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_32
		do
			Result := integer_32_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_integer_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): INTEGER_64
		do
			Result := integer_64_converter.substring_as_type (str, start_index, end_index)
		end

feature -- Natural substrings

	substring_to_natural_8 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_8
		do
			Result := natural_8_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_natural_16 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_16
		do
			Result := natural_16_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_natural_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_32
		do
			Result := natural_32_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_natural_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_64
		do
			Result := natural_64_converter.substring_as_type (str, start_index, end_index)
		end

feature -- Real substrings

	substring_to_real_32 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): REAL_32
		do
			Result := real_32_converter.substring_as_type (str, start_index, end_index)
		end

	substring_to_real_64 (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): REAL_64
		do
			Result := real_64_converter.substring_as_type (str, start_index, end_index)
		end

feature -- Numeric conversion

	to_integer (str: READABLE_STRING_GENERAL): INTEGER
		require
			integer_string: is_integer (str)
		do
			Result := integer_32_converter.as_type (str)
		end

	to_natural (str: READABLE_STRING_GENERAL): NATURAL_32
		require
			natural_string: is_natural (str)
		do
			Result := natural_32_converter.as_type (str)
		end

	to_natural_64 (str: READABLE_STRING_GENERAL): NATURAL_64
		require
			natural_string: is_natural (str)
		do
			Result := natural_64_converter.as_type (str)
		end

feature -- Numeric tests

	is_integer (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := integer_32_converter.is_convertible (str)
		end

	is_natural (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := natural_32_converter.is_convertible (str)
		end

	is_natural_64 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := natural_64_converter.is_convertible (str)
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
		item_type_id: INTEGER; value_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; left_adjusted: BOOLEAN
	): BOOLEAN
		-- `True' if split items in `value_list' can be converted to type `item_type_id'
		do
			Result := True
			if attached filled_split_list (value_list, separator, left_adjusted.to_integer) as list then
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
				Result := {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.EL_MAKEABLE_FROM_STRING__STRING_GENERAL)
			end
		end

	is_convertible_tuple (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN): BOOLEAN
		local
			type_array: EL_TUPLE_TYPE_ARRAY; type_id: INTEGER
		do
			if csv_list.occurrences (',') + 1 >= tuple.count then
				type_array := Tuple_.type_array (tuple)
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
				Result := {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.EL_MAKEABLE_FROM_STRING__STRING_GENERAL)
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
			convertable: is_convertible_list (item_type_id, csv_list, ',', left_adjusted)
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
			type_array := Tuple_.type_array (tuple)
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
			filled: Tuple_.is_filled (tuple, 1, tuple.count)
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

			elseif {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.EL_MAKEABLE_FROM_STRING__STRING_GENERAL)
				and then attached Makeable_from_string_factory.new_item_factory (type_id) as factory
			then
				inspect string_storage_type (str)
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

			elseif {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.EL_MAKEABLE_FROM_STRING__STRING_GENERAL)
				and then attached Makeable_from_string_factory.new_item_factory (type_id) as factory
			then
				inspect string_storage_type (str)
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

			${INTEGER_8}, ${INTEGER_16}, ${INTEGER_32}, ${INTEGER_64},

			${NATURAL_8}, ${NATURAL_16}, ${NATURAL_32, ${NATURAL_64},

			${REAL_32}, ${REAL_64},

			${BOOLEAN}, ${CHARACTER_8}, ${CHARACTER_32},

			${STRING_8}, ${STRING_32},
			${IMMUTABLE_STRING_8}, ${IMMUTABLE_STRING_32},

			${ZSTRING},
			${DIR_PATH}, ${FILE_PATH},

			${EL_DIR_URI_PATH}, ${EL_FILE_URI_PATH}

	]"
end