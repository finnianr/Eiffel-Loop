note
	description: "Test class ${C_NULLED_STRING_8_NAME_CACHE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-07-30 07:48:00 GMT (Thursday 30th July 2026)"
	revision: "1"

class
	C_NULLED_STRING_8_NAME_CACHE_TEST_SET

inherit
	EL_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["key_indexed_arrayed_map_list",	agent test_key_indexed_arrayed_map_list]
			>>)
		end

feature -- Test

	test_key_indexed_arrayed_map_list
		-- CONTAINER_STRUCTURE_TEST_SET.key_indexed_arrayed_map_list
		note
			testing: "[
				covers/{EL_KEY_INDEXED_ARRAYED_MAP_LIST}.binary_search,
				covers/{C_NULLED_STRING_8_NAME_CACHE}.item
			]"
		local
			cache: C_NULLED_STRING_8_NAME_CACHE
			name: C_STRING_8; name_null_1, name_null_2: C_NULLED_STRING_8
			name_str, dozen_a_words: STRING_8
		do
			create cache.make
			dozen_a_words := "able,archery,android,anchor,average,ant,ancestor,anca,all,attached,artery,arc"
			assert ("one dozen", dozen_a_words.occurrences (',') + 1 = 12)
			across (dozen_a_words + ",Zig,zag,zebra").split (',') as word loop
				name := word
				name_null_1 := cache.item (name)
				name_null_2 := cache.item (name)
				assert ("same reference", name_null_1 = name_null_2)

				create name_str.make_from_c (name_null_1.area) -- calls C function strlen
				assert ("same name", name_str ~ word)
			end
			assert ("3 buckets have items", cache.used_count = 3)
		end

end
