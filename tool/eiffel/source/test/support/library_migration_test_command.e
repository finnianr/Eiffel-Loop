note
	description: "${LIBRARY_MIGRATION_COMMAND} with debugging output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	LIBRARY_MIGRATION_TEST_COMMAND

inherit
	LIBRARY_MIGRATION_COMMAND
		redefine
			print_iteration, print_class_heading, print_line, prompt_user, print_tab_left
		end

create
	make

feature {NONE} -- Implementation

	print_iteration (i: INTEGER)
		do
			lio.put_integer_field ("ITERATION", i)
			lio.put_new_line
		end

	print_class_heading (name: STRING)
		do
			lio.put_labeled_string ("Class", name)
			lio.put_new_line
			lio.tab_right
			lio.put_new_line
		end

	print_line (line: STRING)
		do
			lio.put_line (line)
		end

	print_tab_left
		do
			lio.tab_left
			lio.put_new_line
		end

	prompt_user (name_array: ARRAY [STRING])
		do
		end

end