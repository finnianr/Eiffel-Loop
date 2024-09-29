note
	description: "Test tables conforming to ${EL_GROUPED_LIST_TABLE [G, HASHABLE]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-26 8:16:06 GMT (Thursday 26th September 2024)"
	revision: "1"

class
	GROUPED_TABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	HEXAGRAM_STRINGS
		rename
			English_titles as I_ching_hexagram_titles,
			Name_list as Mandarin_name_list
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["arrayed_map_to_table",		 agent test_arrayed_map_to_table],
				["function_grouped_set_table", agent test_function_grouped_set_table]
			>>)
		end

feature -- Test

	test_arrayed_map_to_table
		-- CONTAINER_STRUCTURE_TEST_SET.test_arrayed_map_to_table
		note
			testing: "[
				covers/{EL_ARRAYED_MAP_LIST}.to_grouped_list_table,
				covers/{EL_ARRAYED_MAP_LIST}.to_grouped_set_table,
				covers/{EL_INITIALIZED_OBJECT_FACTORY}.new_generic_type_factory,
				covers/{EL_FACTORY_ROUTINES_IMP}.type_hash_key,
				covers/{EL_INTEGER_MATH}.hash_key,
				covers/{EL_INITIALIZED_HASH_TABLE_FACTORY}.new_item,
				covers/{EL_GROUPED_LIST_TABLE_ITERATION_CURSOR}.item
			]"
		local
			word_count_map: like new_word_count_map_list
			word_list: LIST [STRING]; is_word_set: BOOLEAN
			list_counts: ARRAY [INTEGER]; word_size: INTEGER
		do
			word_count_map := new_word_count_map_list
			create list_counts.make_filled (0, 1, 20)
			across <<
				word_count_map.to_grouped_list_table,
				word_count_map.to_grouped_set_table
			>> as grouped_table
			loop
				is_word_set := grouped_table.cursor_index = 2
				if attached {EL_GROUPED_LIST_TABLE [STRING, INTEGER]} grouped_table.item as word_count_table then
					across word_count_table as table loop
						word_size := table.key; word_list := table.item
						if is_word_set then
							inspect word_size
								when 1, 12, 14 then -- Respective examples: "a", "inexperience", "transformation"
									assert ("list and set equal", word_list.count = list_counts [word_size])
							else
							-- duplicate words have been removed
								assert ("fewer set items", word_list.count < list_counts [word_size])
							end
						else
							list_counts [word_size] := table.item_area.count
						end
					end
				end
			end
		end

	test_function_grouped_set_table
		note
			testing: "[
				covers/{EL_ARRAYED_MAP_LIST}.to_grouped_set_table,
				covers/{EL_FUNCTION_GROUPED_SET_TABLE}.make_equal_from_list,
				covers/{EL_INITIALIZED_HASH_TABLE_FACTORY}.new_item,
				covers/{EL_GROUPED_LIST_TABLE_ITERATION_CURSOR}.item
			]"
		local
			word_size: INTEGER
		do
			if attached new_word_count_map_list.to_grouped_set_table as table
				and then attached {EL_GROUPED_SET_TABLE [STRING, INTEGER]} table as set_table_1
				and then attached new_grouped_word_set_table as set_table_2
			then
				assert ("same counts", set_table_1.count = set_table_2.count)
				across set_table_1 as table_1 loop
					word_size := table_1.key
					if set_table_2.has_key (word_size) then
						assert ("same list", table_1.item ~ set_table_2.found_set)
					else
						failed ("set_table_2 has word_size")
					end
				end
			else
				failed ("assign tables")
			end
		end

feature {NONE} -- Implementation

	new_grouped_word_set_table: EL_FUNCTION_GROUPED_SET_TABLE [STRING, INTEGER]
		do
			create Result.make_equal_from_list (agent string_count, new_word_list)
		end

	new_word_count_map_list: EL_ARRAYED_MAP_LIST [INTEGER, STRING]
		-- map word string to word size using I Ching titles
		do
			create Result.make_from_values (new_word_list, agent string_count)
			Result.compare_value_objects
		end

	new_word_list: EL_STRING_8_LIST
		do
			create Result.make (I_ching_hexagram_titles.character_count // 6)
			across I_ching_hexagram_titles as title loop
				across title.item.split (' ') as word loop
					Result.extend (word.item)
					Result.last.to_lower
				end
			end
			Result.do_all (agent {STRING}.prune_all_trailing (','))
			Result.prune_all_empty
		end

	string_count (str: STRING): INTEGER
		do
			Result := str.count
		end

end