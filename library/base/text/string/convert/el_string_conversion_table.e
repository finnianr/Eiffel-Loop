note
	description: "[
		Table of converters conforming to [$source EL_READABLE_STRING_GENERAL_TO_TYPE [ANY]]
		for converting strings conforming to [$source READABLE_STRING_GENERAL] to common data types
	]"
	notes: "[
		Converters:
		
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

			EL_STRING_TO_STRING_8,
			EL_STRING_TO_STRING_32,
			EL_STRING_TO_ZSTRING,
			EL_STRING_TO_DIR_PATH,
			EL_STRING_TO_FILE_PATH,
			EL_STRING_TO_DIR_URI_PATH,
			EL_STRING_TO_FILE_URI_PATH

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "14"

class
	EL_STRING_CONVERSION_TABLE

inherit
	EL_HASH_TABLE [EL_READABLE_STRING_GENERAL_TO_TYPE [ANY], INTEGER]
		rename
			make as make_table
		export
			{NONE} all
			{ANY} has, found_item
		end

	EL_MODULE_EIFFEL

	EL_MODULE_TUPLE
		rename
			Tuple as Mod_tuple
		end

create
	make

feature {NONE} -- Initialization

	make
		local
			type_array: EL_TUPLE_TYPE_ARRAY
		do
			create type_array.make_from_tuple (new_type_tuple)
			make_size (type_array.count)
			across type_array as type loop
				if attached {like item} Eiffel.new_object (type.item) as converter then
					converter.make
					extend (converter, converter.type_id)
				end
			end
		end

feature -- Access

	type_descripton (type: TYPE [ANY]): STRING
		do
			if has_key (type.type_id) then
				Result := found_item.type_description
			else
				create Result.make_empty
			end
		end

	type_list: EL_ARRAYED_LIST [TYPE [ANY]]
		do
			create Result.make (count)
			across current_keys as key loop
				if has_key (key.item) then
					Result.extend (found_item.type)
				end
			end
		end

feature -- Status query

	has_converter (type: TYPE [ANY]): BOOLEAN
		-- `True' if table has converter for `type'
		-- set `found_item' as converter if found
		do
			Result := has_key (type.type_id)
		end

	is_convertible (s: like readable_string; type: TYPE [ANY]): BOOLEAN
		do
			Result := is_convertible_to_type (s, type.type_id)
		end

	is_convertible_list (item_type_id: INTEGER; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN): BOOLEAN
		do
			Result := True
			across new_comma_splitter (csv_list, left_adjusted.to_integer) as list until not Result loop
				Result := is_convertible_to_type (list.item, item_type_id)
			end
		end

	is_convertible_to_type (s: like readable_string; type_id: INTEGER): BOOLEAN
		-- `True' if `str' is convertible to type with `type_id'
		do
			if has_key (type_id) then
				Result := found_item.is_convertible (s)
			end
		end

	is_convertible_tuple (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN): BOOLEAN
		local
			type_array: EL_TUPLE_TYPE_ARRAY; item_type: TYPE [ANY]; type_id: INTEGER
		do
			if csv_list.occurrences (',') + 1 >= tuple.count then
				type_array := Mod_tuple.type_array (tuple)
				Result := True
				across
					new_comma_splitter (csv_list, left_adjusted.to_integer) as list
				until
					not Result or else list.cursor_index > tuple.count
				loop
					if attached list.item as item_str then
						item_type := type_array [list.cursor_index]
						type_id := item_type.type_id
						Result := is_convertible_to_type (item_str, type_id)
					end
				end
			end
		end

feature -- Basic operations

	append_to_chain (
		item_type_id: INTEGER; chain: CHAIN [ANY]; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN
	)
		require
			convertable: is_convertible_list (item_type_id, csv_list, left_adjusted)
		do
			across new_comma_splitter (csv_list, left_adjusted.to_integer) as list loop
				if attached list.item as item_str and then is_convertible_to_type (item_str, item_type_id) then
					chain.extend (to_type_of_type (item_str.twin, item_type_id))
				else
					check i_th_type_convertible: True end
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
		local
			type_array: EL_TUPLE_TYPE_ARRAY; item_type: TYPE [ANY]; type_id: INTEGER
		do
			type_array := Mod_tuple.type_array (tuple)
			across new_comma_splitter (csv_list, left_adjusted.to_integer) as list until list.cursor_index > tuple.count loop
				if attached list.item as item_str then
					item_type := type_array [list.cursor_index]
					type_id := item_type.type_id
					if is_convertible_to_type (item_str, type_id) then
						if tuple.is_reference_item (list.cursor_index) then
							tuple.put_reference (to_type_of_type (item_str.twin, type_id), list.cursor_index)
						else
							tuple.put (to_type_of_type (item_str, type_id), list.cursor_index)
						end
					else
						check i_th_type_convertible: True end
					end
				end
			end
		ensure
			filled: Mod_tuple.is_filled (tuple, 1, tuple.count)
		end

	to_type (str: like readable_string; type: TYPE [ANY]): detachable ANY
		-- `str' converted to type `type'
		require
			convertible: is_convertible_to_type (str, type.type_id)
		do
			Result := to_type_of_type (str, type.type_id)
		end

	to_type_of_type (str: like readable_string; type_id: INTEGER): detachable ANY
		-- `str' converted to type with `type_id'
		require
			convertible: is_convertible_to_type (str, type_id)
		do
			if has_key (type_id) then
				Result := found_item.as_type (str)
			end
		end

feature {NONE} -- Implementation

	new_comma_splitter (csv_list: READABLE_STRING_GENERAL; adjustments: INTEGER): EL_SPLIT_ON_CHARACTER [READABLE_STRING_GENERAL]
		do
			if attached {ZSTRING} csv_list as zstring_list then
				create {EL_SPLIT_ZSTRING_ON_CHARACTER} Result.make_adjusted (zstring_list, ',', adjustments)

			elseif csv_list.is_string_8 then
				create {EL_SPLIT_ON_CHARACTER [STRING_8]} Result.make_adjusted (csv_list.as_string_8, ',', adjustments)

			else
				create {EL_SPLIT_ON_CHARACTER [STRING_32]} Result.make_adjusted (csv_list.as_string_32, ',', adjustments)
			end
		end

	new_type_tuple: TUPLE [
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

			EL_STRING_TO_STRING_8,
			EL_STRING_TO_STRING_32,
			EL_STRING_TO_ZSTRING,
			EL_STRING_TO_DIR_PATH,
			EL_STRING_TO_FILE_PATH,
			EL_STRING_TO_DIR_URI_PATH,
			EL_STRING_TO_FILE_URI_PATH
	]
		do
			create Result
		end

	readable_string: READABLE_STRING_GENERAL
		do
			Result := ""
		end

end