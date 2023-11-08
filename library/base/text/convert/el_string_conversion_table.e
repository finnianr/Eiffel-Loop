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
	date: "2023-11-08 13:52:15 GMT (Wednesday 8th November 2023)"
	revision: "26"

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

	EL_MODULE_EIFFEL; EL_MODULE_NAMING

	EL_MODULE_TUPLE
		rename
			Tuple as Mod_tuple
		end

	EL_SHARED_CLASS_ID; EL_SHARED_FACTORIES

	EL_SHARED_STRING_8_BUFFER_SCOPES; EL_SHARED_STRING_32_BUFFER_SCOPES



create
	make

feature {NONE} -- Initialization

	make
		local
			type_array: EL_TUPLE_TYPE_ARRAY
		do
			create type_array.make_from_tuple (converter_types)
			make_size (type_array.count)
			create integer_converter

			across type_array as type loop
				if type.item ~ integer_converter.type then
					extend (integer_converter, integer_converter.type_id)

				elseif attached {like item} Eiffel.new_object (type.item) as converter then
					converter.make
					extend (converter, converter.type_id)
				end
			end
			create split_list_cache.make (7, agent new_split_list)
		end

feature -- Access

	split_list (value_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; adjustments: INTEGER): like new_split_list
		do
			Result := cached_split_list (value_list, separator, adjustments).twin
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

feature -- Conversion

	to_integer (str: READABLE_STRING_GENERAL): INTEGER
		do
			Result := integer_converter.as_type (str)
		end

feature -- Status query

	has_converter (type: TYPE [ANY]): BOOLEAN
		-- `True' if table has converter for `type'
		-- set `found_item' as converter if found
		do
			Result := has_type (type.type_id)
		end

	is_convertible (str: like readable_string; type: TYPE [ANY]): BOOLEAN
		do
			Result := is_convertible_to_type (str, type.type_id)
		end

	is_convertible_list (
		item_type_id: INTEGER; value_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; adjustments: INTEGER
	): BOOLEAN
		do
			Result := True
			if attached cached_split_list (value_list, separator, adjustments) as list then
				from list.start until not Result or else list.after loop
					Result := is_convertible_to_type (list.item, item_type_id)
					list.forth
				end
			end
		end

	is_convertible_to_type (str: like readable_string; type_id: INTEGER): BOOLEAN
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
			type_array: EL_TUPLE_TYPE_ARRAY; item_type: TYPE [ANY]; type_id: INTEGER
		do
			if csv_list.occurrences (',') + 1 >= tuple.count then
				type_array := Mod_tuple.type_array (tuple)
				Result := True
				if attached cached_split_list (csv_list, ',', left_adjusted.to_integer) as list then
					from list.start until list.after or else not Result or else list.index > tuple.count loop
						if attached list.item as item_str then
							item_type := type_array [list.index]
							type_id := item_type.type_id
							Result := is_convertible_to_type (item_str, type_id)
						end
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

feature -- Basic operations

	append_to_chain (
		item_type_id: INTEGER; chain: CHAIN [ANY]; csv_list: READABLE_STRING_GENERAL; left_adjusted: BOOLEAN
	)
		require
			convertable: is_convertible_list (item_type_id, csv_list, ',', left_adjusted.to_integer)
		do
			if attached cached_split_list (csv_list, ',', left_adjusted.to_integer) as list then
				from list.start until list.after loop
					if attached list.item as item_str and then is_convertible_to_type (item_str, item_type_id) then
						chain.extend (to_type_of_type (item_str.twin, item_type_id))
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
			type_array: EL_TUPLE_TYPE_ARRAY; item_type: TYPE [ANY]; type_id: INTEGER
		do
			type_array := Mod_tuple.type_array (tuple)
			from list.start until list.after or else list.index > tuple.count loop
				if attached list.item as item_str then
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
				end
				list.forth
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
			if {ISE_RUNTIME}.dynamic_type (str) = type_id then
				Result := str

			elseif has_type (type_id) then
				Result := found_item.as_type (str)

			elseif {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.EL_MAKEABLE_FROM_STRING)
				and then attached Makeable_from_string_factory.new_item_factory (type_id) as factory
			then
				if attached {STRING_GENERAL} str as general then
					Result := factory.new_item (general)

				elseif attached {READABLE_STRING_8} str as str_8 then
					across String_8_scope as scope loop
						Result := factory.new_item (scope.copied_item (str_8))
					end
				elseif attached {READABLE_STRING_32} str as str_32 then
					across String_32_scope as scope loop
						Result := factory.new_item (scope.copied_item (str_32))
					end
				end
			end
		end

feature {NONE} -- Implementation

	cached_split_list (csv_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; adjustments: INTEGER): like new_split_list
		do
			if attached split_list_cache.item (csv_list.generating_type) as list then
				list.fill_general (csv_list, separator, adjustments)
				Result := list
			else
				Result := new_split_list ({STRING_8})
			end
		end

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

	new_split_list (type: TYPE [READABLE_STRING_GENERAL]): EL_SPLIT_READABLE_STRING_LIST [READABLE_STRING_GENERAL]
		do
			if type.conforms_to ({ZSTRING}) then
				create {EL_SPLIT_ZSTRING_LIST} Result.make_empty

			elseif type.conforms_to ({READABLE_STRING_32}) then
				create {EL_SPLIT_IMMUTABLE_STRING_32_LIST} Result.make_empty
			else
				create {EL_SPLIT_IMMUTABLE_STRING_8_LIST} Result.make_empty
			end
		end

	readable_string: READABLE_STRING_GENERAL
		do
			Result := ""
		end

feature {NONE} -- Internal attributes

	integer_converter: EL_STRING_TO_INTEGER_32

	split_list_cache: EL_CACHE_TABLE [like new_split_list, TYPE [READABLE_STRING_GENERAL]];

note
	notes: "[
		Conversion targets:

			INTEGER_8, INTEGER_16, INTEGER_32, INTEGER_64,

			NATURAL_8, NATURAL_16, NATURAL_32, NATURAL_64,

			REAL_32, REAL_64,

			BOOLEAN, CHARACTER_8, CHARACTER_32,

			STRING_8, STRING_32, IMMUTABLE_STRING_8, IMMUTABLE_STRING_32,

			[$source ZSTRING],
			[$source DIR_PATH], [$source FILE_PATH],

			[$source EL_DIR_URI_PATH], [$source EL_FILE_URI_PATH]

	]"
end