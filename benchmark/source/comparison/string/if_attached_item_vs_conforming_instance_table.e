note
	description: "[
		Compare conditional assignment depending on consecutive **elseif** attachment attempts to
		two experimental techniques:

		1. ${STRING_ITERATION_CURSOR_TABLE} uses a hash table lookup of type id
		2. ${STRING_ITERATION_CURSOR_TYPE_MAP} uses a linear array search of type id.
	]"
	notes: "[
		**BENCHMARKS**

		Passes over 2000 millisecs (in descending order)

			Class_id inspect        : 192433.0 times (100%)
			if general.is_string_32 : 186552.0 times (-3.1%)
			type id linear search   : 179719.0 times (-6.6%)
			if general.is_string_8  : 168681.0 times (-12.3%)
			type id hash lookup     : 118537.0 times (-38.4%)
			sorter class            :  90702.0 times (-52.9%)
			tuple sorter class      :  87112.0 times (-54.7%)

		Best performing method uses: `Class_id.string_storage_type (general)'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-13 16:41:51 GMT (Sunday 13th April 2025)"
	revision: "9"

class
	IF_ATTACHED_ITEM_VS_CONFORMING_INSTANCE_TABLE

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_CLASS_ID

create
	make

feature -- Access

	Description: STRING = "Alternatives to many elseif attachment attempts"

feature -- Basic operations

	execute
		local
			mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL]
			zstr: ZSTRING; word: READABLE_STRING_GENERAL
		do
			create mixed_string_list.make (100)
			-- even
			across Text.words as list loop
				if attached list.item as word_32 then
					inspect list.cursor_index \\ 3
						when 0 then
							if word_32.is_valid_as_string_8 then
								word := word_32.to_string_8
							else
								word := word_32
							end
						when 1 then
							zstr := word_32
							word := zstr
						when 2 then
							word := word_32
					end
					mixed_string_list.extend (word)
				end
			end

			compare ("compare branching to table", <<
				["if general.is_string_32", agent use_super_readable_elseif (mixed_string_list)],
				["Class_id inspect",			 agent use_super_readable_class_id (mixed_string_list)],
				["tuple sorter class",		 agent use_tuple_sort (mixed_string_list)],
				["sorter class",				 agent use_sorter_class (mixed_string_list)],
				["type id hash lookup",		 agent use_hash_table (mixed_string_list)],
				["type id linear search",	 agent use_map_list (mixed_string_list)]
			>>)
		end

feature {NONE} -- Target routines

	use_map_list (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			super: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			across mixed_string_list as list loop
				super := Extended_string_type_map.extended_string (list.item)
			end
		end

	use_super_readable_class_id (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			super: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]; sc: EL_STRING_GENERAL_ROUTINES
		do
			across mixed_string_list as list loop
				super := sc.super_readable_general (list.item)
			end
		end

	use_super_readable_elseif (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			super: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			across mixed_string_list as list loop
				super := super_readable_elseif (list.item)
			end
		end

	use_sorter_class (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			super: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			across mixed_string_list as list loop
				super := super_readable_sorter_class (list.item)
			end
		end

	use_tuple_sort (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			super: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			across mixed_string_list as list loop
				super := super_readable_tuple_assign (list.item)
			end
		end

feature {NONE} -- Implementation

	super_readable_elseif (general: READABLE_STRING_GENERAL): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			if general.is_string_32 then
				if attached {ZSTRING} general as zstr then
					Result := super_z (zstr)

				elseif attached {READABLE_STRING_32} general as str_32 then
					Result := super_readable_32 (str_32)
				else
					Result := super_readable_32 (general.to_string_32)
				end

			elseif attached {READABLE_STRING_8} general as str_8 then
				Result := super_readable_8 (str_8)
			else
				Result := super_readable_32 (general.to_string_32)
			end
		end

	super_readable_sorter_class (general: READABLE_STRING_GENERAL): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			if attached Type_sorter as sorter then
				sorter.set_from (general)
				inspect sorter.string_storage_type
					when '1' then
						Result := super_readable_8 (sorter.readable_8)

					when '4' then
						Result := super_readable_32 (sorter.readable_32)

					when 'X' then
						Result := super_z (sorter.readable_z)
				end
			end
		end

	super_readable_tuple_assign (general: READABLE_STRING_GENERAL): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		local
			sorter: STRING_TUPLE_ASSIGN_SORTER
		do
			if attached sorter.allocated (general) as tuple then
				inspect tuple.storage_type
					when '1' then
						Result := super_readable_8 (tuple.readable_8)

					when '4' then
						Result := super_readable_32 (tuple.readable_32)

					when 'X' then
						Result := super_z (tuple.readable_Z)
				end
			end
		end

	use_hash_table (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			super: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			across mixed_string_list as list loop
				super := String_cursor.shared (list.item)
			end
		end

feature {NONE} -- Constants

	Extended_string_type_map: EXTENDED_READABLE_STRING_TYPE_MAP
		once
			create Result.make
		end

	String_cursor: EXTENDED_READABLE_STRING_TABLE
			--
		once
			create Result.make
		end

	Type_sorter: STRING_TYPE_SORTER
		once
			create Result
		end

end