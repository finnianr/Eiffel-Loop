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
			EL_STRING_TO_FILE_PATH

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 14:18:29 GMT (Sunday 9th May 2021)"
	revision: "9"

class
	EL_STRING_CONVERSION_TABLE

inherit
	EL_HASH_TABLE [EL_READABLE_STRING_GENERAL_TO_TYPE [ANY], INTEGER]
		rename
			make as make_table
		export
			{NONE} all
			{ANY} has
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
					extend (converter, converter.type_id)
				end
			end
		end

feature -- Status query

	is_convertible (s: like string; type: TYPE [ANY]): BOOLEAN
		do
			Result := is_convertible_to_type (s, type.type_id)
		end

	is_convertible_to_type (s: like string; type_id: INTEGER): BOOLEAN
		-- `True' if `str' is convertible to type with `type_id'
		do
			if has_key (type_id) then
				Result := found_item.is_convertible (s)
			end
		end

	is_convertible_tuple (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN): BOOLEAN
		local
			type_array: EL_TUPLE_TYPE_ARRAY; item_type: TYPE [ANY]; type_id: INTEGER
			list: like new_split_list; item_str: STRING_GENERAL
		do
			if csv_list.occurrences (',') + 1 >= tuple.count then
				type_array := Mod_tuple.type_array (tuple)
				list := new_split_list (csv_list)
				if left_adjusted then
					list.enable_left_adjust
				end
				Result := True
				from list.start until not Result or else (list.index > tuple.count or list.after) loop
					item_str := list.item (False)
					item_type := type_array [list.index]
					type_id := item_type.type_id
					Result := is_convertible_to_type (item_str, type_id)
					list.forth
				end
			end
		end

feature -- Basic operations

	fill_tuple (tuple: TUPLE; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN)
		-- fill tuple with STRING items from comma-separated list `csv_list' of strings
		-- TUPLE may contain any of types in `current_keys'
		-- items are left adjusted if `left_adjusted' is True
		require
			tuple_convertible: is_convertible_tuple (tuple, csv_list, left_adjusted)
		local
			type_array: EL_TUPLE_TYPE_ARRAY; item_type: TYPE [ANY]; type_id: INTEGER
			list: like new_split_list; item_str: STRING_GENERAL
		do
			type_array := Mod_tuple.type_array (tuple)
			list := new_split_list (csv_list)
			if left_adjusted then
				list.enable_left_adjust
			end
			from list.start until list.index > tuple.count or list.after loop
				item_str := list.item (False)
				item_type := type_array [list.index]
				type_id := item_type.type_id
				if is_convertible_to_type (item_str, type_id) then
					if tuple.is_reference_item (list.index) then
						tuple.put_reference (to_type_of_type (item_str.twin, type_id), list.index)
					else
						tuple.put (to_type_of_type (item_str, type_id), list.index)
					end
				else
					check i_th_type_convertible: True end
				end
				list.forth
			end
		ensure
			filled: Mod_tuple.is_filled (tuple, 1, tuple.count)
		end

	to_type (str: like string; type: TYPE [ANY]): detachable ANY
		-- `str' converted to type `type'
		require
			convertible: is_convertible_to_type (str, type.type_id)
		do
			Result := to_type_of_type (str, type.type_id)
		end

	to_type_of_type (str: like string; type_id: INTEGER): detachable ANY
		-- `str' converted to type with `type_id'
		require
			convertible: is_convertible_to_type (str, type_id)
		do
			if has_key (type_id) then
				Result := found_item.as_type (str)
			end
		end

feature {NONE} -- Implementation

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
			EL_STRING_TO_FILE_PATH
	]
		do
			create Result
		end

	new_split_list (csv_list: READABLE_STRING_GENERAL): EL_SPLIT_STRING_LIST [STRING_GENERAL]
		do
			if attached {ZSTRING} csv_list as zstring_list then
				create {EL_SPLIT_ZSTRING_LIST} Result.make (zstring_list, Comma)

			elseif csv_list.is_string_8 then
				create {EL_SPLIT_STRING_8_LIST} Result.make (csv_list.as_string_8, Comma)

			else
				create {EL_SPLIT_STRING_32_LIST} Result.make (csv_list.as_string_32, Comma)
			end
		end

	string: READABLE_STRING_GENERAL
		do
			Result := ""
		end

feature {NONE} -- Constants

	Comma: STRING = ","

end