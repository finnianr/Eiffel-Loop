note
	description: "[
		Compare conditional assignment depending on consecutive **elseif** attachment attempts to
		two experimental techniques:
		
		1. [$source STRING_ITERATION_CURSOR_TABLE] uses a hash table lookup of type id
		2. [$source STRING_ITERATION_CURSOR_TYPE_MAP] uses a linear array search of type id.
	]"
	notes: "[
		**BENCHMARKS**

		Passes over 500 millisecs (in descending order)

			elseif branching      :  57183.0 times (100%)
			type id linear search :  53071.0 times (-7.2%)
			type id hash lookup   :  39105.0 times (-31.6%)
			
		Conclusions **elseif** attachment attempts is marginally faster than the best alternative.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-12 12:52:02 GMT (Sunday 12th November 2023)"
	revision: "1"

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

create
	make

feature -- Access

	Description: STRING = "Alternatives to many elseif attachment attempts"

feature -- Basic operations

	execute
		local
			mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL]
			str_8: STRING; zstr: ZSTRING
			word: READABLE_STRING_GENERAL
		do
			create mixed_string_list.make (100)
			across Text.words as list loop
				if attached list.item as word_32 then
					if word_32.is_valid_as_string_8 then
						str_8 := word_32
						word := str_8

					elseif list.cursor_index \\ 2 = 0 then
						zstr := word_32
						word := zstr
					else
						word := word_32
					end
					mixed_string_list.extend (word)
				end
			end

			compare ("compare branching to table", <<
				["elseif branching 1",	  agent use_elseif_branching_1 (mixed_string_list)],
				["elseif branching 2",	  agent use_elseif_branching_2 (mixed_string_list)],
				["type id hash lookup",	  agent use_hash_table (mixed_string_list)],
				["type id linear search", agent use_map_list (mixed_string_list)]
			>>)
		end

feature {NONE} -- Implementation

	shared_cursor (general: READABLE_STRING_GENERAL): EL_STRING_ITERATION_CURSOR
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

	use_elseif_branching_1 (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			l_cursor: EL_STRING_ITERATION_CURSOR; c: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			across mixed_string_list as list loop
				l_cursor := c.shared_cursor (list.item)
			end
		end

	use_elseif_branching_2 (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			l_cursor: EL_STRING_ITERATION_CURSOR
		do
			across mixed_string_list as list loop
				l_cursor := shared_cursor (list.item)
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

	use_map_list (mixed_string_list: ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			l_cursor: EL_STRING_ITERATION_CURSOR
		do
			across mixed_string_list as list loop
				l_cursor := Cursor_type_map.shared (list.item)
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

end