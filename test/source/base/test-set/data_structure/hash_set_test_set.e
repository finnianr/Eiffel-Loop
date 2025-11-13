note
	description: "Test class ${EL_HASH_SET} and it's descendants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-13 7:24:29 GMT (Thursday 13th November 2025)"
	revision: "7"

class HASH_SET_TEST_SET inherit BASE_EQA_TEST_SET

	EL_STRING_8_CONSTANTS; 	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["hash_set",				  agent test_hash_set],
				["internal_search",		  agent test_internal_search],
				["internal_table_search", agent test_internal_table_search],
				["put",						  agent test_put],
				["set_operations",		  agent test_set_operations],
				["string_sets",			  agent test_string_sets]
			>>)
		end

feature -- Test

	test_hash_set
		-- HASH_SET_TEST_SET.hash_set
		note
			testing: "[
				covers/{EL_HASH_SET}.has,
				covers/{EL_HASH_SET}.has_key,
				covers/{EL_HASH_SET}.is_equal,
				covers/{EL_HASH_SET}.make_from,
				covers/{EL_HASH_SET}.put,
				covers/{EL_HASH_SET}.put_copy,
				covers/{EL_HASH_SET}.prune,
				covers/{EL_HASH_SET}.wipe_out
			]"
		local
			code_set: EL_HASH_SET [INTEGER]; range_0_to_9, range_0_to_4: INTEGER_INTERVAL
			set_1, set_2: EL_HASH_SET [ZSTRING]; continent_set: EL_HASH_SET [STRING]
		do
			if attached Text.lines as lines then
			-- comparison reference VS object
				create set_1.make_from (lines, False)
				assert ("all found", across lines as ln all set_1.has (ln.item) end)
				assert ("none found", across Text.lines as ln all not set_1.has (ln.item) end)

				create set_1.make_from (lines, True)
				assert ("all found", across Text.lines as ln all set_1.has (ln.item) end)

			-- wipe_out, to_list
				create set_1.make_from (lines, True)
				create set_2.make_from (lines, True)
				set_2.wipe_out
				assert ("is empty", set_2.count = 0)
				assert ("is empty", set_2.to_list.is_empty)
				across set_1.to_list as list loop
					set_2.put (list.item)
				end
				assert ("same sets", set_1 ~ set_2)

			-- prune
				range_0_to_9 := 0 |..| 9
				create code_set.make_from (range_0_to_9, False)
				assert ("10 items", code_set.count = 10)

				range_0_to_4 := 0 |..| 4
				across range_0_to_4 as code loop
					code_set.prune (code.item)
				end
				assert ("same count", code_set.count = range_0_to_9.count - range_0_to_4.count)

			-- put, put_copy, has_key
				continent_set := Text.continents
				continent_set.put_copy (Empty_string_8)
				assert ("has empty", continent_set.has (Empty_string_8))
				continent_set.put_copy (Empty_string_8)
				if continent_set.has_key (Empty_string_8) then
					assert ("same value", continent_set.found_item ~ Empty_string)
					assert ("different references", continent_set.found_item /= Empty_string)
				end
			end
		end

	test_internal_search
		-- HASH_SET_TEST_SET.internal_search
		-- Based on a list of class name set items known to have at one time caused a failure
		-- The order is significant
		note
			testing: "[
				covers/{EL_HASH_SET_BASE}.internal_search
			]"
		local
			evolicity_class, name: STRING; evolicity_class_removed: BOOLEAN
			name_set, library_set: EL_HASH_SET [STRING]
		do
			library_set := new_class_set (Class_set_1)
			name_set := new_class_set (Class_set_2)
			evolicity_class := "EVOLICITY_GETTER_FUNCTION_TABLE"
		--	Reproduce `name_set.intersect (library_set)'
			across name_set.query_not_in (library_set) as list loop
				name := list.item
				name_set.prune (name)
				if name ~ evolicity_class then
					evolicity_class_removed := True

				elseif not evolicity_class_removed and then not name_set.has (evolicity_class) then
					failed ("set has " + evolicity_class)
				end
			end
			assert ("two items", name_set.count = 2)
		-- `intersect' post-condition
			assert ("is subset", name_set.is_subset (library_set))
		end

	test_internal_table_search
		-- HASH_SET_TEST_SET.internal_table_search
		-- Based on a list of class name set items known to have at one time caused a failure
		-- The order is significant
		note
			testing: "[
				covers/{SEARCH_TABLE}.internal_search,
				covers/{SEARCH_TABLE}.prune
			]"
		local
			evolicity_class, name: STRING; evolicity_class_removed: BOOLEAN
			name_set: SEARCH_TABLE [STRING]; library_set: EL_HASH_SET [STRING]
			name_list: EL_STRING_8_LIST
		do
			library_set := new_class_set (Class_set_1)
			name_set := new_class_table (Class_set_2)
			evolicity_class := "EVOLICITY_GETTER_FUNCTION_TABLE"
		--	Reproduce `name_set.intersect (library_set)'
			create name_list.make_from_iterable (name_set.linear_representation, False)
			across name_list.query_not_in (library_set) as list loop
				name := list.item
				name_set.prune (name)
				if name ~ evolicity_class then
					evolicity_class_removed := True

				elseif not evolicity_class_removed and then not name_set.has (evolicity_class) then
					failed ("set has " + evolicity_class)
				end
			end
			assert ("two items", name_set.count = 2)
		end

	test_put
		-- HASH_SET_TEST_SET.put
		note
			testing: "[
				covers/{EL_HASH_SET}.put
			]"
		local
			word_set: EL_HASH_SET [STRING]; word_table: HASH_TABLE [STRING, STRING]
			word_count: INTEGER; sg: EL_STRING_GENERAL_ROUTINES
		do
			create word_set.make_equal (1)
			create word_table.make_equal (1)

			across Hexagram.English_titles_first.split (' ') as split loop
				if attached split.item as word then
					word_set.put (word)
					word_table.put (word, word)
					assert ("both inserted", word_set.inserted = word_table.inserted)
					word_count := word_count + 1
				end
			end
			assert ("same count", word_set.count = word_table.count)
			lio.put_integer_field ("word count", word_count)
			lio.put_integer_field (" unique word count", word_set.count)
			lio.put_new_line
		end

	test_set_operations
		-- HASH_SET_TEST_SET.set_operations
		note
			testing: "[
				covers/{EL_HASH_SET}.disjoint,
				covers/{EL_HASH_SET}.is_equal,
				covers/{EL_HASH_SET}.is_subset,
				covers/{EL_HASH_SET}.make_from,
				covers/{EL_HASH_SET}.make,
				covers/{EL_HASH_SET}.make_equal,
				covers/{EL_HASH_SET}.merge,
				covers/{EL_HASH_SET}.put
				covers/{EL_HASH_SET}.subset_include,
				covers/{EL_HASH_SET}.subset_exclude,
				covers/{EL_HASH_SET}.subtract,
				covers/{EL_HASH_SET}.to_list
			]"
		local
			set_all, set_latin_1, set_not_latin_1: EL_HASH_SET [ZSTRING]
		do
			if attached Text.lines as lines then
				create set_all.make_from (lines, True)

				set_latin_1 := set_all.subset_include (agent {ZSTRING}.is_valid_as_string_8)
				set_not_latin_1 := set_all.subset_exclude (agent {ZSTRING}.is_valid_as_string_8)

				assert ("4 Latin-1 strings", set_latin_1.count = 4)
				assert ("Total - Latin-1 count", lines.count - set_latin_1.count = set_not_latin_1.count)
				assert ("disjoint sets", set_latin_1.disjoint (set_not_latin_1))

				assert ("subset of all", set_latin_1.is_subset (set_all))

				set_all.subtract (set_latin_1)
				assert ("remaining not Latin-1", set_all ~ set_not_latin_1)
				if attached set_all.to_list as not_latin_1_list then
					assert ("same count", not_latin_1_list.count = set_all.count)
				end

				set_all.merge (set_latin_1)
				assert ("Full set again", set_all.count = Text.lines.count)
				print_set ("set_all [%S]", set_all)
				print_set ("set_not_latin_1 [%S]", set_not_latin_1)
				set_all.intersect (set_not_latin_1)
				assert ("remaining not Latin-1", set_all ~ set_not_latin_1)
			end
		end

	print_set (label: STRING; set: EL_HASH_SET [ZSTRING])
		do
			across set.to_list as list loop
				lio.put_index_labeled_string (list, label, list.item)
				lio.put_new_line
			end
			lio.put_new_line
		end

	test_string_sets
		-- HASH_SET_TEST_SET.string_sets
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_8_SET}.make,
				covers/{EL_IMMUTABLE_KEY_8_LOOKUP}.has_key,
				covers/{EL_NAME_SET}.same_keys,
				covers/{EL_HASH_SET}.make_from
			]"
		local
			word_set: EL_IMMUTABLE_STRING_8_SET; name_set: EL_NAME_SET
			name_table: SEARCH_TABLE [STRING]
		do
			if attached Text.latin_1_words as word_list then
				create word_set.make (word_list.joined_lines)
				create name_set.make_equal (word_set.count)
				create name_table.make (word_set.count)
				across word_set as set loop
				-- Post-condition for {IMMUTABLE_STRING_8}.same_characters fails, so use STRING_8
					if attached set.item.as_string_8 as str then
						name_set.put (str)
						name_table.put (str)
					end
				end
				across word_list as list loop
					if attached list.item as word then
						assert ("set member", word_set.has_key (word))
						assert_same_string (Void, word_set.found_item, word)
						assert ("name set has", name_set.has_key (word))
						assert_same_string (Void, name_set.found_item, word)
					end
				end
			end
		end

feature {NONE} -- Implementation

	new_class_set (lines: STRING): EL_HASH_SET [STRING]
		do
			create Result.make_from (lines.split ('%N'), True)
		end

	new_class_table (lines: STRING): SEARCH_TABLE [STRING]
		do
			create Result.make (lines.occurrences ('%N') + 1)
			across lines.split ('%N') as list loop
				Result.put (list.item)
			end
		end

feature {NONE} -- Constants

	Class_set_1: STRING = "[
		EL_COPY_FILE_IMPL
		EL_OS_COMMAND
		EL_COMMAND_IMPL
		EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND
		EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND
		EL_COPY_FILE_COMMAND
		EL_FIND_OS_COMMAND
		EL_MP3_CONVERT_COMMAND
		EL_FILE_SYSTEM_OS_COMMAND
	]"

	Class_set_2: STRING = "[
		EL_MP3_CONVERT_COMMAND
		EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND
		EL_MP3_CONVERT_IMPL
		EL_MODULE_ENVIRONMENT
		EL_MODULE_LOG
		INTEGER
		FILE_NAME
		ARRAY
		CHARACTER
		EVOLICITY_GETTER_FUNCTION_TABLE
		REAL_REF
		STRING
	]"

end