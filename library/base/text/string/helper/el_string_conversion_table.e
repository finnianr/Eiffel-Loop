note
	description: "[
		Table of routines to convert strings conforming to [$source READABLE_STRING_GENERAL] to commonly used types
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 18:03:37 GMT (Tuesday 2nd March 2021)"
	revision: "4"

class
	EL_STRING_CONVERSION_TABLE

inherit
	EL_HASH_TABLE [
		TUPLE [is_convertible: PREDICATE [READABLE_STRING_GENERAL]; to_type: FUNCTION [READABLE_STRING_GENERAL, ANY]],
		INTEGER -- type_id
	]
		rename
			make as make_table
		end

	EL_SHARED_CLASS_ID

	EL_MODULE_TUPLE
		rename
			Tuple as Mod_tuple
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_table (<<
				[({INTEGER_8}).type_id,			[agent {like string}.is_integer_8, agent {like string}.to_integer_8]],
				[({INTEGER_16}).type_id, 		[agent {like string}.is_integer_16, agent {like string}.to_integer_16]],
				[({INTEGER_32}).type_id,		[agent {like string}.is_integer_32, agent {like string}.to_integer_32]],
				[({INTEGER_64}).type_id,		[agent {like string}.is_integer_64, agent {like string}.to_integer_64]],

				[({NATURAL_8}).type_id,			[agent {like string}.is_natural_8, agent {like string}.to_natural_8]],
				[({NATURAL_16}).type_id,		[agent {like string}.is_natural_16, agent {like string}.to_natural_16]],
				[({NATURAL_32}).type_id,		[agent {like string}.is_natural_32, agent {like string}.to_natural_32]],
				[({NATURAL_64}).type_id,		[agent {like string}.is_natural_64, agent {like string}.to_natural_64]],

				[({DOUBLE}).type_id,				[agent {like string}.is_double, agent {like string}.to_double]],
				[({REAL}).type_id,				[agent {like string}.is_real, agent {like string}.to_real]],

				[({BOOLEAN}).type_id,			[agent {like string}.is_boolean, agent {like string}.to_boolean]],
				[({CHARACTER_8}).type_id,		[agent is_character_8, agent to_character_8]],
				[({CHARACTER_32}).type_id,		[agent is_character_32, agent to_character_32]],

				[Class_id.STRING_8,				[agent {like string}.is_valid_as_string_8, agent {like string}.to_string_8]],
				[Class_id.STRING_32,				[agent is_valid_as_string_32, agent {like string}.to_string_32]],
				[Class_id.ZSTRING,				[agent is_valid_as_zstring, agent to_zstring]],
				[Class_id.EL_DIR_PATH,			[agent is_valid_as_dir_path, agent to_dir_path]],
				[Class_id.EL_FILE_PATH,			[agent is_valid_as_file_path, agent to_file_path]]
			>>)
		end

feature -- Status query

	is_convertible (s: like string; type: TYPE [ANY]): BOOLEAN
		do
			Result := is_convertible_to_type (s, type.type_id)
		end

	is_convertible_to_type (s: like string; type_id: INTEGER): BOOLEAN
		-- `True' if `str' is convertible to type with `type_id'
		local
			convertible: PREDICATE [like string]
		do
			if has_key (type_id) then
				convertible := found_item.is_convertible
				Result := convertible (s)
			end
		end

	is_convertible_tuple (tuple: TUPLE; csv_list: STRING_GENERAL; left_adjusted: BOOLEAN): BOOLEAN
		local
			tuple_type: TYPE [TUPLE]; item_type: TYPE [ANY]; type_id: INTEGER
			list: like new_split_list; item_str: STRING_GENERAL
		do
			if csv_list.occurrences (',') + 1 >= tuple.count then
				tuple_type := tuple.generating_type
				list := new_split_list (csv_list)
				if left_adjusted then
					list.enable_left_adjust
				end
				Result := True
				from list.start until not Result or else (list.index > tuple.count or list.after) loop
					item_str := list.item (False)
					item_type := tuple_type.generic_parameter_type (list.index)
					type_id := item_type.type_id
					Result := is_convertible_to_type (item_str, type_id)
					list.forth
				end
			end
		end

feature -- Basic operations

	fill_tuple (tuple: TUPLE; csv_list: STRING_GENERAL; left_adjusted: BOOLEAN)
		-- fill tuple with STRING items from comma-separated list `csv_list' of strings
		-- TUPLE may contain any of types in `current_keys'
		-- items are left adjusted if `left_adjusted' is True
		require
			tuple_convertible: is_convertible_tuple (tuple, csv_list, left_adjusted)
		local
			tuple_type: TYPE [TUPLE]; item_type: TYPE [ANY]; type_id: INTEGER
			list: like new_split_list; item_str: STRING_GENERAL
		do
			tuple_type := tuple.generating_type
			list := new_split_list (csv_list)
			if left_adjusted then
				list.enable_left_adjust
			end
			from list.start until list.index > tuple.count or list.after loop
				item_str := list.item (False)
				item_type := tuple_type.generic_parameter_type (list.index)
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
		local
			string_to_type: FUNCTION [like string, ANY]
		do
			if has_key (type_id) then
				string_to_type := found_item.to_type
				Result := string_to_type (str)
			end
		end

feature {NONE} -- Implementation

	is_character_32 (str: like string): BOOLEAN
		do
			Result := str.count = 1
		end

	is_character_8 (str: like string): BOOLEAN
		do
			Result := str.count = 1 and then str.code (1) <= 0xFF
		end

	is_valid_as_string_32, is_valid_as_zstring, is_valid_as_file_path, is_valid_as_dir_path (str: like string): BOOLEAN
		do
			Result := True
		end

	new_split_list (csv_list: STRING_GENERAL): EL_SPLIT_STRING_LIST [STRING_GENERAL]
		do
			if csv_list.is_string_8 then
				create {EL_SPLIT_STRING_8_LIST} Result.make (csv_list.as_string_8, Comma)
			else
				create {EL_SPLIT_STRING_32_LIST} Result.make (csv_list.as_string_32, Comma)
			end
		end

	to_character_32 (str: like string): CHARACTER_32
		require
			is_character_32: is_character_32 (str)
		do
			if is_character_32 (str) then
				Result := str.item (1)
			end
		end

	to_character_8 (str: like string): CHARACTER_8
		require
			is_character_8: is_character_8 (str)
		do
			if is_character_8 (str) then
				Result := str.item (1).to_character_8
			end
		end

	to_dir_path (str: like string): EL_DIR_PATH
		do
			create Result.make (str)
		end

	to_file_path (str: like string): EL_FILE_PATH
		do
			create Result.make (str)
		end

	to_zstring (str: like string): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.as_zstring (str)
		end

	string: READABLE_STRING_GENERAL
		do
			Result := ""
		end

feature {NONE} -- Constants

	Comma: STRING = ","

end