note
	description: "Eiffel name translateable test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 15:23:10 GMT (Saturday 29th March 2025)"
	revision: "13"

class
	EIFFEL_NAME_TRANSLATEABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["class_as_kebab_lower", agent test_class_as_kebab_lower],
				["class_as_snake_lower", agent test_class_as_snake_lower],
				["class_as_snake_upper", agent test_class_as_snake_upper],
				["class_name_words",		 agent test_class_name_words],
				["naming",					 agent test_naming],
				["type_name",				 agent test_type_name]
			>>)
		end

feature -- Tests

	test_class_as_kebab_lower
		do
			assert_same_string (Void, Naming.class_as_kebab_lower (Current, 1, 2), "name-translateable")
		end

	test_class_as_snake_lower
		local
			head_count, tail_count: INTEGER; name: STRING
		do
			if attached generator.split ('_') as word_list then
				across word_list as word loop
					head_count := word.cursor_index - 1
					tail_count := word_list.count - word.cursor_index
					name := word.item.as_lower
					lio.put_index_labeled_string (head_count, "head_count = ", name)
					lio.put_new_line
					across << Current, generating_type >> as object loop
						assert_same_string (
							Void, Naming.class_as_snake_lower (object.item, head_count, tail_count), name
						)
					end
				end
			end
		end

	test_class_as_snake_upper
		local
			name: STRING
		do
			name := Naming.class_as_snake_upper ({EL_SPLIT_ON_CHARACTER_8 [STRING_8]}, 3, 0)
			assert_same_string (Void, name, "CHARACTER_8")
		end

	test_class_name_words
		-- EIFFEL_NAME_TRANSLATEABLE_TEST_SET.test_class_name_words
		note
			testing: "[
				covers/{EL_CLASS_NAME_WORDS}.remove_el_prefix,
				covers/{EL_CLASS_NAME_WORDS}.description
			]"
		local
			name_words: EL_CLASS_NAME_WORDS; description: STRING
		do
			across 1 |..| 2 as n loop
				create name_words.make_from_type ({EL_COPY_TREE_COMMAND_IMP})
				if n.item = 1 then
					name_words.remove_el_prefix
					name_words.remove_suffix (<< "IMP", "COMMAND" >>)
				else
					name_words.remove_words (<< "EL", "IMP", "COMMAND" >>)
				end
				assert_same_string (Void, name_words.as_word_string, "COPY TREE")
			end

			if attached Naming.new_type_words ({EL_SPLIT_READABLE_STRING_LIST [STRING]}) as words then
				words.remove_el_prefix
				description := words.description
			end
			assert ("expected description", description ~ "Split readable string list for type STRING_8")

			if attached Naming.new_class_words (Current) as words then
				words.remove_el_prefix
				description := words.description
			end
			assert ("expected description", description ~ "Eiffel name translateable test SET")
		end

	test_naming
		note
			testing: "[
				covers/{EL_NAMING_ROUTINES}.to_title,
				covers/{EL_CLASS_NAME_WORDS}.remove_el_prefix,
				covers/{EL_CLASS_NAME_WORDS}.description
			]"
		local
			eif_name, title: STRING
		do
			eif_name := "hex_11_software"
			create title.make (eif_name.count)
			Naming.to_title (eif_name, title, ' ', Naming.empty_word_set)
			assert ("is title", title ~ "Hex 11 Software")
		end

	test_type_name
		local
			name: STRING
		do
			name := Naming.type_name ({LIST [STRING_8]})
			assert_same_string (Void, name, "LIST [STRING_8]")
		end

end