note
	description: "[
		Compare conditional assignment depending on consecutive **elseif** attachment attempts to
		two experimental techniques:
		
		1. [$source STRING_ITERATION_CURSOR_TABLE] uses a hash table lookup of type id
		2. [$source STRING_ITERATION_CURSOR_TYPE_MAP] uses a linear array search of type id.
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

		Best performing method uses: `Class_id.character_bytes (general)'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-13 17:44:17 GMT (Monday 13th November 2023)"
	revision: "2"

class
	IF_ATTACHED_ITEM_VS_CONFORMING_INSTANCE_TABLE

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_STRING_8_CURSOR
		rename
			cursor_8 as shared_cursor_8
		end

	EL_SHARED_STRING_32_CURSOR
		rename
			cursor_32 as shared_cursor_32
		end

	EL_SHARED_ZSTRING_CURSOR
		rename
			cursor as shared_cursor_z
		end

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
				["if general.is_string_32", agent use_shared_cursor_elseif (mixed_string_list)],
				["Class_id inspect",			 agent use_shared_cursor_class_id (mixed_string_list)],
				["tuple sorter class",		 agent use_tuple_sort (mixed_string_list)],
				["sorter class",				 agent use_sorter_class (mixed_string_list)],
				["type id hash lookup",		 agent use_hash_table (mixed_string_list)],
				["type id linear search",	 agent use_map_list (mixed_string_list)]
			>>)
		end

feature {NONE} -- Target routines

	use_map_list (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			l_cursor: EL_STRING_ITERATION_CURSOR
		do
			across mixed_string_list as list loop
				l_cursor := Cursor_type_map.shared (list.item)
			end
		end

	use_shared_cursor_class_id (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			l_cursor: EL_STRING_ITERATION_CURSOR; c: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			across mixed_string_list as list loop
				l_cursor := c.shared_cursor (list.item)
			end
		end

	use_shared_cursor_elseif (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			l_cursor: EL_STRING_ITERATION_CURSOR
		do
			across mixed_string_list as list loop
				l_cursor := shared_cursor_elseif (list.item)
			end
		end

	use_sorter_class (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			l_cursor: EL_STRING_ITERATION_CURSOR
		do
			across mixed_string_list as list loop
				l_cursor := shared_cursor_sorter_class (list.item)
			end
		end

	use_tuple_sort (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			l_cursor: EL_STRING_ITERATION_CURSOR
		do
			across mixed_string_list as list loop
				l_cursor := shared_cursor_tuple_assign (list.item)
			end
		end

feature {NONE} -- Implementation

	shared_cursor_elseif (general: READABLE_STRING_GENERAL): EL_STRING_ITERATION_CURSOR
		do
			if general.is_string_32 then
				if attached {EL_READABLE_ZSTRING} general as zstr then
					Result := shared_cursor_z (zstr)

				elseif attached {READABLE_STRING_32} general as str_32 then
					Result := shared_cursor_32 (str_32)
				else
					Result := shared_cursor_32 (general.to_string_32)
				end

			elseif attached {READABLE_STRING_8} general as str_8 then
				Result := shared_cursor_8 (str_8)
			else
				Result := shared_cursor_32 (general.to_string_32)
			end
		end

	shared_cursor_sorter_class (general: READABLE_STRING_GENERAL): EL_STRING_ITERATION_CURSOR
		do
			if attached Type_sorter as sorter then
				sorter.set_from (general)
				inspect sorter.character_bytes
					when '1' then
						Result := shared_cursor_8 (sorter.readable_8)

					when '4' then
						Result := shared_cursor_32 (sorter.readable_32)

					when 'X' then
						Result := shared_cursor_z (sorter.readable_z)
				end
			end
		end

	shared_cursor_tuple_assign (general: READABLE_STRING_GENERAL): EL_STRING_ITERATION_CURSOR
		local
			sorter: STRING_TUPLE_ASSIGN_SORTER
		do
			if attached sorter.allocated (general) as tuple then
				inspect tuple.character_bytes
					when '1' then
						Result := shared_cursor_8 (tuple.readable_8)

					when '4' then
						Result := shared_cursor_32 (tuple.readable_32)

					when 'X' then
						Result := shared_cursor_z (tuple.readable_Z)
				end
			end
		end

	use_hash_table (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			l_cursor: EL_STRING_ITERATION_CURSOR
		do
			across mixed_string_list as list loop
				l_cursor := String_cursor.shared (list.item)
			end
		end

feature {NONE} -- Constants

	Cursor_type_map: STRING_ITERATION_CURSOR_TYPE_MAP
		once
			create Result.make
		end

	String_cursor: STRING_ITERATION_CURSOR_TABLE
			--
		once
			create Result.make
		end

	Type_sorter: STRING_TYPE_SORTER
		once
			create Result
		end

end