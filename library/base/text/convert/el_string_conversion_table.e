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
	date: "2025-03-24 7:16:45 GMT (Monday 24th March 2025)"
	revision: "44"

class
	EL_STRING_CONVERSION_TABLE

inherit
	EL_HASH_TABLE [EL_READABLE_STRING_GENERAL_TO_TYPE [ANY], INTEGER]
		rename
			make as make_sized,
			has_key as has_type
		export
			{NONE} all
			{ANY} has, has_type, found_item
		end

	EL_STRING_NUMERIC_CONVERSION
		rename
			make as make_numeric
		undefine
			copy, default_create, is_equal
		end

	EL_MODULE_EIFFEL; EL_MODULE_NAMING

	EL_MODULE_TUPLE
		rename
			Tuple as Tuple_
		end

	EL_STRING_POOL_ROUTINES; EL_SHARED_FACTORIES; EL_SHARED_CLASS_ID

create
	make

feature {NONE} -- Initialization

	make
		local
			type_array: EL_TUPLE_TYPE_ARRAY
		do
			make_numeric

			create boolean_8_converter.make

			create character_8_converter.make
			create character_32_converter.make

			split_list_area := new_split_list_types.area

			create type_array.make_from_tuple (converter_types)
			make_sized (type_array.count)

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
			valid_type_1: split_list_by_type ('1') = split_list_area [0]
			valid_type_4: split_list_by_type ('4') = split_list_area [1]
			valid_type_X: split_list_by_type ('X') = split_list_area [2]
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
			across key_list as key loop
				if has_type (key.item) then
					Result.extend (found_item.type)
				end
			end
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

	is_convertible_tuple (
		tuple: TUPLE; part_list: READABLE_STRING_GENERAL; separator: CHARACTER; left_adjusted: BOOLEAN
	): BOOLEAN
		local
			type_array: EL_TUPLE_TYPE_ARRAY; type_id: INTEGER
		do
			if part_list.occurrences (separator) + 1 >= tuple.count then
				type_array := Tuple_.type_array (tuple)
				Result := True
				if attached filled_split_list (part_list, separator, left_adjusted.to_integer) as list then
					from list.start until list.after or else not Result or else list.index > tuple.count loop
						type_id := type_array [list.index].type_id
						Result := is_substring_convertible_to_type (part_list, list.item_lower, list.item_upper, type_id)
						list.forth
					end
				end
			end
		end

	is_latin_1 (type: TYPE [ANY]): BOOLEAN
		-- `True' if type can be always be represented by Latin-1 encoded string
		do
			if has_type (type.type_id) then
				Result := found_item.is_latin_1
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

	fill_tuple (tuple: TUPLE; part_list: READABLE_STRING_GENERAL; separator: CHARACTER; left_adjusted: BOOLEAN)
		-- fill tuple with STRING items from `part_list' of strings separated by `separator'
		-- TUPLE may contain any of types in `current_keys'
		-- items are left adjusted if `left_adjusted' is True
		require
			tuple_convertible: is_convertible_tuple (tuple, part_list, separator, left_adjusted)
		do
			fill_tuple_from_list (tuple, split_list (part_list, separator, left_adjusted.to_integer))
		end

	fill_tuple_from_list (tuple: TUPLE; list: like split_list)
		require
			same_count: list.count = tuple.count
		local
			type_array: EL_TUPLE_TYPE_ARRAY; l_item_type: TYPE [ANY]
			type_id, lower, upper, index: INTEGER
		do
			type_array := Tuple_.type_array (tuple)
			if attached list.target_string as list_string then
				from list.start until list.after or else list.index > tuple.count loop
					index := list.index
					l_item_type := type_array [index]
					lower := list.item_lower; upper := list.item_upper
					type_id := l_item_type.type_id
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
				and then attached string_pool (str).borrowed_item as borrowed
			then
				Result := factory.new_item (borrowed.copied_substring (str, start_index, end_index))
				borrowed.return
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
				and then attached string_pool (str).borrowed_item as borrowed
			then
				Result := factory.new_item (borrowed.copied (str))
				borrowed.return
			end
		end

feature {NONE} -- Factory

	new_expanded_table: EL_HASH_TABLE [EL_READABLE_STRING_GENERAL_TO_TYPE [ANY], TYPE [ANY]]
		local
			current_object: REFLECTED_REFERENCE_OBJECT; i, type_id: INTEGER
		do
			create Result.make (20)
			create current_object.make (Current)
			from i := 1 until i > current_object.field_count loop
				type_id := current_object.field_static_type (i)
				if {ISE_RUNTIME}.type_conforms_to (type_id, Converter_base_id)
					and then attached current_object.reference_field (i) as ref
					and then attached {EL_READABLE_STRING_GENERAL_TO_TYPE [ANY]} ref as converter
				then
					Result.extend (converter, converter.generating_type)
				end
				i := i + 1
			end
		end

	new_split_list_types: ARRAY [EL_SPLIT_READABLE_STRING_LIST [READABLE_STRING_GENERAL]]
		do
			Result := <<
				create {EL_SPLIT_IMMUTABLE_STRING_8_LIST}.make_empty,
				create {EL_SPLIT_IMMUTABLE_STRING_32_LIST}.make_empty,
				create {EL_SPLIT_ZSTRING_LIST}.make_empty
			>>
		end

feature {NONE} -- Implementation

	converter_types: TUPLE [
			EL_STRING_TO_INTEGER_8,
			EL_STRING_TO_INTEGER_16,
			EL_STRING_TO_INTEGER_32,
			EL_STRING_TO_INTEGER_64,

			EL_STRING_TO_NATURAL_8,
			EL_STRING_TO_NATURAL_16,
			EL_STRING_TO_NATURAL_32,
			EL_STRING_TO_NATURAL_64,

			EL_STRING_TO_REAL_32,
			EL_STRING_TO_REAL_64,

			EL_STRING_TO_BOOLEAN,
			EL_STRING_TO_CHARACTER_8,
			EL_STRING_TO_CHARACTER_32,

			EL_STRING_TO_STRING_8, EL_STRING_TO_STRING_32, EL_STRING_TO_ZSTRING,
			EL_STRING_TO_IMMUTABLE_STRING_8, EL_STRING_TO_IMMUTABLE_STRING_32,

			EL_STRING_TO_DIR_PATH, EL_STRING_TO_FILE_PATH,
			EL_STRING_TO_DIR_URI_PATH, EL_STRING_TO_FILE_URI_PATH
	]
		do
			create Result
		end

	filled_split_list (
		csv_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; adjustments: INTEGER
	): like new_split_list_types.item
		-- reusable split list
		do
			Result := split_list_by_type (string_storage_type (csv_list))
			Result.fill_general (csv_list, separator, adjustments)
		end

	split_list_by_type (storage_type: CHARACTER): like new_split_list_types.item
		-- reusable split list
		require
			valid_type: valid_string_storage_type (storage_type)
		do
			inspect storage_type
				when '1' then
					Result := split_list_area [0]
				when '4' then
					Result := split_list_area [1]
				when 'X' then
					Result := split_list_area [2]
			end
		end

feature {NONE} -- Internal attributes

	boolean_8_converter: EL_STRING_TO_BOOLEAN

	character_32_converter: EL_STRING_TO_CHARACTER_32

	character_8_converter: EL_STRING_TO_CHARACTER_8

	split_list_area: SPECIAL [like new_split_list_types.item]

feature {NONE} -- Constants

	Converter_base_id: INTEGER
		once
			Result := ({EL_READABLE_STRING_GENERAL_TO_TYPE [ANY]}).type_id
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