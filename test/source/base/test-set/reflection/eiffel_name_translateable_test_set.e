note
	description: "Eiffel name translateable test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-06 14:41:48 GMT (Sunday 6th August 2023)"
	revision: "12"

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
				["class_as_snake_upper", agent test_class_as_snake_upper],
				["class_as_snake_lower", agent test_class_as_snake_lower],
				["naming",					 agent test_naming]
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

	test_naming
		note
			testing: "covers/{EL_NAMING_ROUTINES}.to_title",
						"covers/{EL_NAMING_ROUTINES}.class_description"
		local
			eif_name, title, description: STRING
			excluded_words: EL_STRING_8_LIST
		do
			eif_name := "hex_11_software"
			create title.make (eif_name.count)
			Naming.to_title (eif_name, title, ' ', Naming.empty_word_set)
			assert ("is title", title ~ "Hex 11 Software")

			excluded_words := "EL"
			description := Naming.class_description_from ({EL_SPLIT_READABLE_STRING_LIST [STRING]}, excluded_words)
			assert ("expected description", description ~ "Split readable string list for type STRING_8")

			description := Naming.class_description_from (Current, excluded_words)
			assert ("expected description", description ~ "Eiffel name translateable test SET")
		end

end