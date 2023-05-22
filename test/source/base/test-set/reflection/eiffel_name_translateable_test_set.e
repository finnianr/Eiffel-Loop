note
	description: "Eiffel name translateable test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-22 9:10:11 GMT (Monday 22nd May 2023)"
	revision: "9"

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
				["class_as_snake_lower", agent test_class_as_snake_lower]
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
					assert_same_string (
						Void, Naming.class_as_snake_lower (Current, head_count, tail_count), name
					)
					assert_same_string (
						Void, Naming.class_as_snake_lower (generating_type, head_count, tail_count), name
					)
				end
			end
		end

end